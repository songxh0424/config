#if(Sys.getenv("TERM") == "xterm-256color")
  library("colorout")

sshhh <- function(a.package){
  suppressWarnings(suppressPackageStartupMessages(
    library(a.package, character.only=TRUE)))
}

# auto.loads <-c("dplyr", "stringr")
# 
# if(interactive()){
#   invisible(sapply(auto.loads, sshhh))
# }

q <- function (save="no", ...) {
  quit(save=save, ...)
}
