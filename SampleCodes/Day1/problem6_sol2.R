# install.packages("quantmod")
library(quantmod)

?debug
?browser

# set debug to getSymbols and call it!
# commands: n, s, f, Q, c, help, where
debug(getSymbols)
getSymbols("^TWII")


# unset debug to getSymbols and call it!
undebug(getSymbols)
getSymbols("^TWII")


# set debugger at getSymbols.yahoo
debug(getSymbols.yahoo)
getSymbols("^TWII")
undebug(getSymbols.yahoo)


# set debugger at getSymbols.yahoo
debug(getSymbols.oanda)
getSymbols("USD/TWD",src="oanda")
undebug(getSymbols.oanda)


# set debugger at download.file
debug(download.file)
getSymbols("^DJI")
undebug(download.file)
