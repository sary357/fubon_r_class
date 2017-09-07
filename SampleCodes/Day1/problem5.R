######################################################################
### addXXX methods & to.period methods
######################################################################

library(quantmod)
Xt = getSymbols("USD/TWD",src="oanda",auto.assign = F)
chartSeries(Xt)
chartSeries(to.weekly(Xt))
Xt = to.weekly(Xt)


# add + TAB
add 

addSAR()
addSMA()
addBBands()

# [hint] TAB with package::
TTR::

# try BBands
BBands(Xt)

# [hint] TAB with func (watching args)
BBands
args(BBands)

bb <- BBands(HLC(Xt),n=60)
tail(bb)

