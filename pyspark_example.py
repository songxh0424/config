from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession, HiveContext, SQLContext
from pyspark.sql import functions as F
from pyspark.sql.functions import col
from pyspark.sql.types import FloatType
from pyspark.ml.classification import LogisticRegression, GBTClassifier, RandomForestClassifier
from pyspark.ml.feature import OneHotEncoderEstimator, StringIndexer, VectorAssembler
from pyspark.ml import Pipeline
from pyspark.ml.evaluation import BinaryClassificationEvaluator
from pyspark.ml.tuning import ParamGridBuilder, TrainValidationSplit
from sklearn.metrics import precision_recall_curve, roc_curve
import pandas as pd
import numpy as np

sp = SparkSession.builder.appName("DY Recruit") \
                 .config('spark.driver.memory', '12G') \
                 .config('spark.executor.memory', '8G') \
                 .config('spark.yarn.executor.memoryOverhead', '3G') \
                 .enableHiveSupport().getOrCreate()
sc = sp.sparkContext
hc = HiveContext(sc)

# sp.sql('USE commsaide')
df = hc.table('commsaide.408_all')

df = df.drop('yuid').withColumnRenamed('user_id', 'yuid')

## ignore the non-US users
df_all = df.filter(df['dv_all'] > 0) \
           .fillna(0, subset = ['dv_' + x for x in ['imap', 'app', 'mweb', 'dweb', 'home', 'news', 'finance', 'sports']] + \
                   [x + '_cnt' for x in ['open', 'star', 'linkclick', 'delete', 'spam']] + \
                   [x + '_cnt_ymail' for x in ['open', 'star', 'linkclick', 'delete', 'spam']])
## drop the users that have delivered == 0 (in DY audience but not receiving emails)
df_all = df_all.fillna(-1, subset = ['gender', 'age', 'reg_date'])
## drop users with missing reg_date
df_all = df_all.filter(df_all['reg_date'] != -1)
## account age
df_all = df_all.withColumn('account_age', F.round((1567296000 - df_all['reg_date']) / (3600 * 24))).drop('reg_date')
df_all.groupby('flag_dy').count().show()
# +-------+--------+
# |flag_dy|   count|
# +-------+--------+
# |      1|17988265|
# |      0|85309330|
# +-------+--------+

################################################################################
## prepare data for modeling
################################################################################
## training samples, positive class is users who opened/clicked
df_dy = df_all.filter((df_all['flag_dy'] == 1) & (df_all['delivered'] > 0)).withColumn('target', F.when(df_all['open'] + df_all['click'] > 0, 1).otherwise(0))
## account age
# df_dy = df_dy.withColumn('account_age', F.round((1567296000 - df_dy['reg_date']) / (3600 * 24))).drop('reg_date')

categoricalColumns = ['gender']
stages = []
for categoricalCol in categoricalColumns:
    stringIndexer = StringIndexer(inputCol = categoricalCol, outputCol = categoricalCol + 'Index')
    encoder = OneHotEncoderEstimator(inputCols=[stringIndexer.getOutputCol()], outputCols=[categoricalCol + "classVec"])
    stages += [stringIndexer, encoder]

label_stringIdx = StringIndexer(inputCol = 'target', outputCol = 'label')
stages += [label_stringIdx]
numericCols = ['dv_' + x for x in ['all', 'imap', 'app', 'mweb', 'dweb', 'home', 'news', 'finance', 'sports']] + ['age', 'account_age'] + [x + '_cnt' for x in ['open', 'star', 'linkclick', 'delete', 'spam']] + [x + '_cnt_ymail' for x in ['open', 'star', 'linkclick', 'delete', 'spam']]
assemblerInputs = [c + "classVec" for c in categoricalColumns] + numericCols
assembler = VectorAssembler(inputCols=assemblerInputs, outputCol="features")
stages += [assembler]


## use users who click as positive class
df_click = df_dy.withColumn('target', F.when((df_dy['click'] > 0) & (df_dy['unsub'] == 0) & (df_dy['flag_unsub'] == 0), 1).otherwise(0))
df_click.groupby(col('target')).count().show()
# +------+--------+
# |target|   count|
# +------+--------+
# |     1| 6568502|
# |     0|10267677|
# +------+--------+

pipeline = Pipeline(stages = stages)
pipelineModel = pipeline.fit(df_click)
df_click = pipelineModel.transform(df_click)
cols = df_click.columns
selectedCols = ['label', 'features'] #+ cols
df_click = df_click.select(selectedCols)
df_click.printSchema()

train, test = df_click.randomSplit([0.8, 0.2], seed = 12345)
evaluator = BinaryClassificationEvaluator()

## logistic regression
lr = LogisticRegression(maxIter = 20)
paramGrid = ParamGridBuilder()\
    .addGrid(lr.regParam, [0.1, 0.01]) \
    .addGrid(lr.fitIntercept, [True])\
    .addGrid(lr.elasticNetParam, [0.0, 0.5, 1.0])\
    .build()
tvs = TrainValidationSplit(estimator=lr,
                           estimatorParamMaps=paramGrid,
                           evaluator=evaluator,
                           # 80% of the data will be used for training, 20% for validation.
                           trainRatio=0.8)
lrModel = tvs.fit(train)
predictions = lrModel.transform(test)
# predictions.show(10, False)
print('Test Area Under ROC', evaluator.evaluate(predictions)) ## 0.733
print('regParam:', lrModel.bestModel._java_obj.getRegParam(), 'fitIntercept:', lrModel.bestModel._java_obj.getFitIntercept(),
      'elasticNetParam:', lrModel.bestModel._java_obj.getElasticNetParam()) ## 0.01, True, 0

## gradient boosted trees
gbt = GBTClassifier(maxIter = 20)
paramGrid = ParamGridBuilder() \
    .addGrid(gbt.maxBins, [32, 48, 64]) \
    .addGrid(gbt.maxDepth, [5, 7]) \
    .build()
tvs = TrainValidationSplit(estimator=gbt,
                           estimatorParamMaps=paramGrid,
                           evaluator=evaluator,
                           # 80% of the data will be used for training, 20% for validation.
                           trainRatio=0.8)
gbtModel = tvs.fit(train)
predictions = gbtModel.transform(test)
# predictions.show(10, False)
print('Test Area Under ROC', evaluator.evaluate(predictions)) ## 0.77
print('MaxIter:', gbtModel.bestModel._java_obj.getMaxIter(), 'MaxBins:', gbtModel.bestModel._java_obj.getMaxBins(),
      'MaxDepth:', gbtModel.bestModel._java_obj.getMaxDepth()) ## 20, 32, 7
## precision recall curve
labelAndProb = predictions.select('label','probability') \
    .rdd.map(lambda row: (float(row['probability'][1]), float(row['label']))) \
    .collect()
y_score, y_true = zip(*labelAndProb)
precision, recall, thresholds = precision_recall_curve(y_true, y_score)
pr_table = pd.DataFrame(data = {'precision': precision, 'recall': recall, 'threshold': pd.np.append(thresholds, [1])})
inds = range(0, pr_table.shape[0], pr_table.shape[0] // 50)
pr_table.iloc[inds, :]


## random forests
rf = RandomForestClassifier()
paramGrid = ParamGridBuilder()\
    .addGrid(rf.maxBins, [32, 48, 64]) \
    .addGrid(rf.maxDepth, [5, 7])\
    .addGrid(rf.numTrees, [50, 100])\
    .build()
tvs = TrainValidationSplit(estimator=rf,
                           estimatorParamMaps=paramGrid,
                           evaluator=evaluator,
                           # 80% of the data will be used for training, 20% for validation.
                           trainRatio=0.8)
rfModel = tvs.fit(train)
predictions = rfModel.transform(test)
# predictions.show(10, False)
print('Test Area Under ROC', evaluator.evaluate(predictions)) ## 0.76
print('numTrees:', rfModel.bestModel._java_obj.getNumTrees(), 'MaxBins:', rfModel.bestModel._java_obj.getMaxBins(),
      'MaxDepth:', rfModel.bestModel._java_obj.getMaxDepth()) ## 50, 64, 7

## predict non-DY users using GBT model
## IMAP only users
df_nondy = df_all.filter((df_all['flag_dy'] == 0) & (df_all['flag_unsub'] == 0)).withColumn('target', F.lit(0))
df_imap = df_nondy.filter((df_nondy['dv_mweb'] == 0) & (df_nondy['dv_dweb'] == 0) & (df_nondy['dv_app'] == 0) & (df_nondy['dv_imap'] > 0))
pipelineModel_new = pipeline.fit(df_imap)
df_new = pipelineModel_new.transform(df_imap)
df_new = df_new.select(['features', 'label', 'yuid'])
# predictions = gbtModel.transform(df_new.sample(False, 0.01, seed = 123))
# pred = predictions.select('label','probability') \
#                   .rdd.map(lambda row: (float(row['probability'][1]), float(row['label']))) \
#                   .collect()
# y_score, _ = zip(*pred)
# recruits = np.empty(len(inds))
# for i in range(len(inds)):
#     thres = thresholds[inds[i]]
#     recruits[i] = np.mean(y_score >= thres)
# pr_table_short = pr_table.iloc[inds]
# pr_table_short['ratio'] = recruits
predictions = gbtModel.transform(df_new)
getProb = F.udf(lambda row: float(row[1]), FloatType())
pred = predictions.withColumn('prob', getProb('probability')).select(['yuid', 'prob'])
pred.write.saveAsTable("commsaide.408_imap_only_1st")
# pred = pred.orderBy(pred['prob'].desc()).limit(10000000)

## IMAP only prediction with GBT
df_click_imap = df_click.filter((df_click['dv_mweb'] == 0) & (df_click['dv_dweb'] == 0) & (df_click['dv_app'] == 0) & (df_click['dv_imap'] > 0))
pipelineModel = pipeline.fit(df_click_imap)
df_click_imap = pipelineModel.transform(df_click_imap)
cols = df_click_imap.columns
selectedCols = ['label', 'features'] #+ cols
df_click_imap = df_click_imap.select(selectedCols)

train_imap, test_imap = df_click_imap.randomSplit([0.8, 0.2], seed = 12345)
predictions = gbtModel.transform(test_imap)
# predictions.show(10, False)
print('Test Area Under ROC', evaluator.evaluate(predictions)) ##
