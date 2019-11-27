##Start a PySpark Shell in Terminal
##/mnt/alpha/3p/spark/bin/pyspark --executor-memory 16g --total-executor-cores 100 --executor-cores 10 --conf spark.ui.port=4446

##Import Pyspark SQL Modules
from pyspark.sql.functions import col, desc, to_timestamp, unix_timestamp, countDistinct, lit, sum, from_unixtime, count, row_number, rank, when, date_format, lower, expr, least, greatest, monotonically_increasing_id, length, regexp_replace
from pyspark.sql.types import *
from pyspark.sql.window import Window

##Load Parquet Data by Date
def load_data(startDate,endDate, data_dir, time_col):
    start_ymd = dt.strptime(startDate, "%Y-%m-%d")
    end_ymd = dt.strptime(endDate, "%Y-%m-%d")
    start_ymd_utc = start_ymd.replace(tzinfo=timezone('UTC'))
    end_ymd_utc = end_ymd.replace(tzinfo=timezone('UTC'))
    delta = end_ymd - start_ymd
    file_path = []
    for i in range(delta.days + 1 + 1):
        d = start_ymd + timedelta(days =i)
        file_path.append(data_dir + "/date="+str(d.year) + "-" + str(d.month).zfill(2) + "-"+str(d.day).zfill(2) + "/*/*.parquet")
    df = spark.read.load(file_path)
    df = df.where((col(time_col) > start_ymd_utc) & (col(time_col) < end_ymd_utc + timedelta(days = 1)))
    return(df)


##Load csv/tsv
df = spark.read.option("header", "true").option("delimiter", "\t").csv("data_dir/*.tsv")
df = spark.read.format("com.databricks.spark.csv").load("/tmp/bing/*.csv", header = True)

##Create an empty dataframe
field = [StructField("_c0", StringType(), True), StructField("_c1", LongType(), True)]
schema = StructType(field)
df = sqlContext.createDataFrame(sc.emptyRDD(), schema)

##Cache Data
df = df.cache()

##To check the schema
df
df.printSchema()

##Check Data (Indicate false to avoid texts being truncated.)
df.show(50,False)

##Check DF Size
df.count()

##Create Column and Change Column Name
df = df.withColumn("col_name_1", lower(col("col_name_1")))
df = df.withColumn("col_name_1", lit(1))
df = df.withColumn("time", regexp_replace(col("time"), "-(\\d{2})(\\d{2})", "-$1:$2"))
df = df.withColumnRenamed("col_name_1", "col_name_2").withColumnRenamed("col_name_3", "col_name_4")

##Filter
df_fltr = df.where(~col("col_name_1").isin(fltr_list))
##Assign a filter query to variable
fltr = (~col("col_name_1").isin(fltr_list))
fltr_1 = (col("col_name_2") == fltr_str)
fltr = fltr & fltr_1
df_fltr = df.where(fltr)
##Filter on Regex Like
df_fltr = df.where(lower(col("col_name_1")).rlike("abc"))
##Filter on Substr
df_fltr = df_fltr.where(col("time").substr(1,10) != "2019-04-25")
##Filter on a Dict Column
df_fltr = df.where(col("col_name_1").getItem("key_1").isNotNull()).where(length(col("col_name_1").getItem("key_2")) == 36)

##Timestamp Related
timeFmt1 = "yyyy-MM-dd'T'HH:mm:ss'Z'"
timeFmt2 = "yyyy-MM-dd HH:mm:ss"
timeFmt3 = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
timeFmt4 = "%Y-%m-%d"
fltr = (unix_timestamp("time1",format=timeFmt1)<unix_timestamp("time2",format=timeFmt2)+0*3600*24)
df = df.withColumn("time1", to_timestamp("time1", format=timeFmt1))
df_1 = df.withColumn("timeUTC", from_unixtime(unix_timestamp("time",format=timeFmt3), timeFmt1)).drop("time")

##Select Specific Columns and then distinct
df_fltr = df_fltr.select("col_name_2", "col_name_3", "col_name_4").distinct()

##Aggregation
##Count Distinct
df_agg = df.groupBy(col("col_name_1")).agg(countDistinct("col_name_2").alias("agg_name_2"), countDistinct("col_name_3").alias("agg_name_3"))

##Window Function
df = df.withColumn("freq", count("col_name_1").over(Window.partitionBy("col_name_2")))
func_1 = Window.partitionBy("col_name_1").orderBy(desc("col_name_2"))

##Join df
df_join = df_1.join(df_2, df_1.col_name_1 == df_2.col_name_2, how = "left_anti").drop("col_name_2")

##Union df
df = df.union(df_1)

##Sampling
sample_ratio = 0.2
df = df.sample(True, sample_ratio).distinct()

##Collect Data
var_list_1 = df.select("col_name_1").limit(1).collect()
var_1 = var_list_1[0][0]

##Sort
df = df.sort("col_name_1").limit(100)
df.sort(desc("col_name_1")).show(100,False)

##Convert to Pandas DF
df_pd = df.toPandas()

## Write to HDFS
df.write.csv('/tmp/bing/',header=True, compression="gzip")
## Save into one single file
df.coalesce(1).write.csv("/tmp/bing/")


##Run python file directly
##/mnt/alpha/3p/spark/bin/spark-submit --executor-memory 16g --total-executor-cores 50 --executor-cores 10 --conf spark.ui.port=4446  /home/alpha/bing/submit.py "app_name" "variable_2"
from pyspark.sql.functions import col, desc, unix_timestamp, sum, lit, countDistinct, row_number, from_unixtime, rank
from pyspark.sql.types import *
from pyspark.sql.window import Window
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext

##Spark Session
spark = SparkSession\
    .builder\
    .appName(sys.argv[1])\
    .getOrCreate()
sqlContext = SQLContext(spark)
