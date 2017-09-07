library(foreach)

# Like lapply
foreach(x = 1:10) %do% (x+1) 
lapply(1:10,function(x) x+1)


# rbind results
library(magrittr)
lapply(1:10,function(x) c(x,x+1)) %>% do.call(rbind,.)

foreach(x = 1:10) %do% c(x,x+1) 
foreach(x = 1:10,.combine = rbind) %do% c(x,x+1) 
foreach(x = 1:10,.combine = rbind,.multicombine = T) %do% c(x,x+1) 



