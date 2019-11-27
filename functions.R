library(ggplot2)
library(ggthemes)
library(DT)
library(scales)
library(plotly)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(grid)
library(gridExtra)
library(lubridate)
library(knitr)
library(kableExtra)

custom_colors = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33", "#FFA500", "#3cb371", "#1E90FF")
## plotting and theming functions
theme_Publication <- function(base_size=10, legend.pos = 'bottom') {
  t = (theme_foundation(base_size=base_size)
       + theme(plot.title = element_text(face = "bold",
                                         size = rel(1.2), hjust = 0.5),
               text = element_text(),
               panel.background = element_rect(colour = NA),
               plot.background = element_rect(colour = NA),
               panel.border = element_rect(colour = NA),
               axis.title = element_text(face = "bold",size = rel(1)),
               axis.title.y = element_text(angle=90,vjust =2),
               axis.title.x = element_text(vjust = -0.2),
               axis.text = element_text(),
               axis.line = element_line(colour="black"),
               axis.ticks = element_line(),
               panel.grid.major = element_line(colour="#f0f0f0"),
               panel.grid.minor = element_blank(),
               legend.key = element_rect(colour = NA),
               legend.position = legend.pos,
               legend.title = element_text(face="italic"),
               plot.margin=unit(c(10,5,5,5),"mm")
      ))
  return(t)
}

scale_fill_Publication <- function(colors = custom_colors, ...){
      library(scales)
      discrete_scale("fill","Publication",manual_pal(values = rep(colors, 2)), ...)
}

scale_colour_Publication <- function(colors = custom_colors, ...){
      library(scales)
      discrete_scale("colour","Publication",manual_pal(values = rep(colors, 2)), ...)
}

plot_custom = function(p, saveTo = NULL, palette = 'tableau10', base_size=10, legend.pos = "right", color = TRUE, fill = FALSE, colors = custom_colors, integerx = FALSE, xlim = NULL, ylim = NULL) {
  out = p + expand_limits(y = 0) + theme_Publication(base_size, legend.pos)
  ## if(color) out = out + scale_colour_tableau(palette = palette)
  ## if(fill) out = out + scale_fill_tableau(palette = palette)
  if(color) out = out + scale_colour_Publication(colors = colors)
  if(fill) out = out + scale_fill_Publication(colors = colors)
  if(integerx) out = out + scale_x_continuous(breaks = pretty_breaks())
  if(!is.null(xlim)) out = out + xlim(xlim)
  if(!is.null(ylim)) out = out + ylim(ylim)
  if(is.null(saveTo)) return(out)
  ggsave(saveTo, out)
  return(out)
}


## plotting shorthands
plot_trend = function(dat, x, y, color = NULL, xlab = x, ylab = y, n.xticks = 5, n.yticks = 5, ...) {
  if(is.null(color)) {
    p = dat %>% ggplot(aes_string(x, y)) +
      geom_line(color = '#386cb0') +
      geom_point(size = 1, color = '#386cb0') +
      xlab(xlab) + ylab(ylab)
  } else {
    dat.agg = dat %>% group_by_at(vars(c(x, color))) %>%
      ## summarise_at(vars(y), funs(sum))
      summarise_at(vars(y), list(sum))
    p = dat.agg %>% ggplot(aes_string(x, y, color = color)) + geom_line() + geom_point(size = 1) +
      xlab(xlab) + ylab(ylab)
    ## scale_x_continuous(breaks = pretty_breaks(n = n.xticks)) +
    ## scale_y_continuous(breaks = pretty_breaks(n = n.yticks))
  }
  plot_custom(p, ...) %>% ggplotly()
}

## formatting functions
percent = function(x) {
  round(x * 100, 2)
}

formatNum = function(x) {
  prettyNum(round(x, 2), big.mark = ',')
}

## format table to be printed by kable
quickable = function(df, full_width = T, ...) {
  types = df %>% head %>% collect %>% lapply(class) %>% unlist
  idx = which(types %in% c('integer', 'numeric'))
  df = df %>% mutate_at(vars(names(df)[idx]), funs(. %>% formatNum()))
  kable(df, ...) %>% kable_styling(full_width = full_width)
}

## ratio test
ratio_test = function(df, group_idx, den_idx, num_idx) {
  tmp = df %>%
    mutate(sx = df[[den_idx]]^2,
           sy = df[[num_idx]]^2,
           sxy = df[[den_idx]] * df[[num_idx]]) %>%
    group_by_at(names(df)[group_idx]) %>%
    mutate(n = n()) %>%
    summarise_at(vars(c(names(df)[c(den_idx, num_idx)], 'sx', 'sy', 'sxy', 'n')),
                 funs(. %>% mean())) %>%
    rename_('ax' = names(df)[den_idx], 'ay' = names(df)[num_idx]) %>%
    mutate(r = ay / ax,
           vr = ((ay / ax)^2 * (n / (n-1) * (sx - ax^2)) -
                 2 * (ay / ax) * (n / (n - 1) * (sxy - ax * ay)) +
                 (n / (n - 1) * (sy - ay^2))) / (n * (ax^2)))

  ## z1 = with(tmp, abs(r[2] - r[1]) / sqrt(vr[1] + vr[2]))
  ## p1 = 1 - pnorm(z1)

  ## z2 = with(tmp, abs(r[3] - r[1]) / sqrt(vr[1] + vr[3]))
  ## p2 = 1 - pnorm(z2)

  ## test.table = data.frame(Test = c('backet 1 vs 2', 'backet 1 vs 3'),
  ##                         stats1 = c(tmp$r[1], tmp$r[1]),
  ##                         stats2 = tmp$r[2:3],
  ##                         'z score' = c(z1, z2),
  ##                         'p value' = c(p1, p2),
  ##                         Significance = ifelse(c(p1, p2) < 0.05, 'Yes', 'No'))

  z = with(tmp, abs(r - r[1]) / sqrt(vr + vr[1]))
  p = 1 - pnorm(z)

  test.table = data.frame(Test = paste('bucket 1 vs', 1:length(z)),
                          stats1 = rep(tmp$r[1], length(z)),
                          stats2 = tmp$r,
                          'z score' = z,
                          'p value' = p,
                          Significance = ifelse(p < 0.05, 'Yes', 'No')
                          )

  return(test.table)
  ## kable(test.table)
}

## data table display
quickdt = function(df, solidHeader = FALSE, border = FALSE, filterPos = 'top', pageLen = 10, rowNames = TRUE) {
  sdom = ifelse(nrow(df) <= 10, '<"top">t<"bottom">', '<"top">lrt<"bottom">ip')
  filterPos = ifelse(nrow(df) <= 10, 'none', filterPos)
  types = df %>% head %>% collect %>% lapply(class) %>% unlist
  idx = which(types %in% c('integer', 'numeric'))
  df = df %>% mutate_at(vars(names(df)[idx]), funs(. %>% formatNum()))
  if(solidHeader) {
    datatable(df, selection = 'multiple', escape = FALSE,
              options = list(initComplete = JS(
                               "function(settings, json) {",
                               "$(this.api().table().header()).css({'background-color': '#808080', 'color': '#fff'});",
                               "}"),
                             sDom = sdom),
              filter = filterPos,
              rownames = rowNames)
  } else {
    datatable(df, selection = 'multiple', escape = FALSE,
              options = list(pageLength = pageLen,
                             sDom = sdom),
              filter = filterPos,
              rownames = rowNames)
  }
}

## testing
quicktest = function(df, group_idx, metric_idx, alternative = 'two.sided') {
  bucket_ids = unique(df[[group_idx]])
  bucket_ids = bucket_ids[order(bucket_ids)]
  control = df[[metric_idx]][df[[group_idx]] == bucket_ids[1]]
  ps = numeric(length(bucket_ids) - 1)
  m1 = numeric(length(bucket_ids) - 1)
  m2 = numeric(length(bucket_ids) - 1)
  for(i in 2:length(bucket_ids)) {
    ## test[[paste0('test', i)]] = df[[col]][df$bucket_id == bucket_ids[i]]
    test = df[[metric_idx]][df[[group_idx]] == bucket_ids[i]]
    ps[i - 1] = t.test(control, test, alternative = alternative)$p.value
    m1[i - 1] = mean(control)
    m2[i - 1] = mean(test)
  }
  result = data.frame(stats1 = m1, stats2 = m2, `p-value` = ps) %>%
    mutate(Significance = if_else(ps < 0.05 / (length(bucket_ids) - 1), 'Yes', 'No'))
  return(result)
}


#++++++++++++++++++++++++++++++++++
# rquery.wordcloud() : Word cloud generator
# - http://www.sthda.com
#+++++++++++++++++++++++++++++++++++
# x : character string (plain text, web url, txt file path)
# type : specify whether x is a plain text, a web page url or a file path
# lang : the language of the text
# excludeWords : a vector of words to exclude from the text
# textStemming : reduces words to their root form
# colorPalette : the name of color palette taken from RColorBrewer package,
  # or a color name, or a color code
# min.freq : words with frequency below min.freq will not be plotted
# max.words : Maximum number of words to be plotted. least frequent terms dropped
# value returned by the function : a list(tdm, freqTable)
rquery.wordcloud <- function(x, type=c("text", "url", "file"),
                          lang="english", excludeWords=NULL,
                          textStemming=FALSE,  colorPalette="Dark2",
                          min.freq=3, max.words=200, rot.per = 0.20)
{
  library("tm")
  library("SnowballC")
  library("wordcloud")
  library("RColorBrewer")

  if(type[1]=="file") text <- readLines(x)
  else if(type[1]=="url") text <- html_to_text(x)
  else if(type[1]=="text") text <- x

  # Load the text as a corpus
  docs <- Corpus(VectorSource(text))
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove stopwords for the language
  docs <- tm_map(docs, removeWords, stopwords(lang))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Remove your own stopwords
  if(!is.null(excludeWords))
    docs <- tm_map(docs, removeWords, excludeWords)
  # Text stemming
  if(textStemming) docs <- tm_map(docs, stemDocument)
  # Create term-document matrix
  tdm <- TermDocumentMatrix(docs)
  m <- as.matrix(tdm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  # check the color palette name
  if(!colorPalette %in% rownames(brewer.pal.info)) colors = colorPalette
  else colors = brewer.pal(8, colorPalette)
  # Plot the word cloud
  set.seed(1234)
  wordcloud(d$word,d$freq, min.freq=min.freq, max.words=max.words,
            random.order=FALSE, rot.per=rot.per,
            use.r.layout=FALSE, colors=colors)

  invisible(list(tdm=tdm, freqTable = d))
}

rquery.wordcloud.table <- function(x, type=c("text", "url", "file"),
                          lang="english", excludeWords=NULL,
                          textStemming=FALSE,  colorPalette="Dark2",
                          min.freq=3, max.words=200, rot.per = 0.20)
{
  library("tm")
  library("SnowballC")
  library("wordcloud")
  library("RColorBrewer")

  if(type[1]=="file") text <- readLines(x)
  else if(type[1]=="url") text <- html_to_text(x)
  else if(type[1]=="text") text <- x

  # Load the text as a corpus
  docs <- Corpus(VectorSource(text))
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove stopwords for the language
  docs <- tm_map(docs, removeWords, stopwords(lang))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Remove your own stopwords
  if(!is.null(excludeWords))
    docs <- tm_map(docs, removeWords, excludeWords)
  # Text stemming
  if(textStemming) docs <- tm_map(docs, stemDocument)
  # Create term-document matrix
  tdm <- TermDocumentMatrix(docs)
  m <- as.matrix(tdm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  # check the color palette name
  if(!colorPalette %in% rownames(brewer.pal.info)) colors = colorPalette
  else colors = brewer.pal(8, colorPalette)
  # Plot the word cloud
  set.seed(1234)
  return(d)
}
#++++++++++++++++++++++
# Helper function
#++++++++++++++++++++++
# Download and parse webpage
html_to_text<-function(url){
  library(RCurl)
  library(XML)
  # download html
  html.doc <- getURL(url)
  #convert to plain text
  doc = htmlParse(html.doc, asText=TRUE)
 # "//text()" returns all text outside of HTML tags.
 # We also don’t want text such as style and script codes
  text <- xpathSApply(doc, "//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)][not(ancestor::form)]", xmlValue)
  # Format text vector into one character string
  return(paste(text, collapse = " "))
}
