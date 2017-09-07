# install.packages("quantmod")
library(quantmod)

getwd()
# setwd()
list.files()

source("copiedGetSymbols.R")
copiedGetSymbls("^TWII")

source("copiedGetSymbolsPrints.R")
copiedGetSymblsPrints("^TWII")
