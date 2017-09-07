library(readr)

titanic <- read_csv("https://raw.githubusercontent.com/haven-jeon/introduction_to_most_usable_pkgs_in_project/master/bicdata/data/titanic.csv",
col_types = cols(survived = col_character()))
View(titanic)

library(ggplot2)
library(magrittr)
ls()
## 1. ggplot practice
titanic %>% ggplot(mapping=aes(x=pclass)) + geom_bar()

titanic %>% ggplot(mapping=aes(x=pclass, y=sex)) + geom_boxplot()
titanic %>% ggplot(mapping=aes(x=pclass, fill=sex)) + geom_bar()


titanic %>% ggplot(mapping=aes(x=sex, fill=survived)) + geom_bar()

titanic %>%  ggplot(mapping=aes(x=pclass, y=sex, color=survived)) + geom_count()

titanic %>%  ggplot(mapping=aes(x=survived, fill=sex)) +geom_bar() + facet_grid(~pclass)

# y-axis: pclass
# x-axis: sex
titanic %>%  ggplot(mapping=aes(x=survived)) +geom_bar() + facet_grid(pclass~sex)
titanic %>%  ggplot(mapping=aes(x=survived)) +geom_bar() + facet_grid(pclass~.)


###1.2 load 7-11 data
tw711 <- read_csv("E:/Funon-DS-R-sary357/SampleCodes/Day2/tw711/711_stores_df.csv",
col_types = cols(POIID = col_character()))

tw711 %>% ggplot(mapping=aes(x=logitude, y=latitude, color=is7WiFi)) +geom_point()

### 1.3 load lvr_land
library(readr)
lvr_land_df_A_with_gis <- read_csv("E:/Funon-DS-R-sary357/SampleCodes/Day2/lvr_land/lvr_land_df_A_with_gis/lvr_land_df_A_with_gis.csv",
col_types = cols(city_id = col_character(),
id = col_character(), town_id = col_character()))
View(lvr_land_df_A_with_gis)
lvr_land_df_A_with_gis %>%  ggplot(mapping=aes(x=logitude_x))

# 2.1 dplyr
library(dplyr)
library(magrittr)
titanic %>%  group_by(survived, sex) %>% summarise(m=n())
titanic %>%  group_by(survived, sex) %>% summarise(m=n(), avg_age=mean(age, na.rm=T))  # na.rm: remove null value

tw711 %>%  group_by(city_name,isATM) %>%  summarise(m=n())
tw711 %>%  group_by(city_name,is7WiFi,isATM) %>%  summarise(m=n() , avg_log=mean(logitude), avg_lat=mean(latitude))

### this mean we have the same function name like lag/filter/intersec
###  因為dplyr是最後面load, 所以如果用其他不同package的時候. 可以用
### like stats::lag(....)
# > library(dplyr)
#
# Attaching package: ‘dplyr’
#
# The following objects are masked from ‘package:stats’:
#   
#  filter, lag
#
# The following objects are masked from ‘package:base’:
#  
#  intersect, setdiff,
# setequal, union


library(RSQLite)
sqlLiteData<-dbDriver('SQLite')
conn<-dbConnect(sqlLiteData, "E:/Funon-DS-R-sary357/SampleCodes/Day2/mydb_r.sqlite")
dbListTables(conn) # list all tables

# the following commands will get all data from remote
# if you need to keep data on remote, please use library(dbplyr)
dbGetQuery(conn,'SELECT city_name, is7Wifi, isATM, count(Address) as m, AVG(logitude) as avg_log FROM "711_stores_df" group by city_name, is7Wifi, isATM') %>% View
dbGetQuery(conn,'SELECT * FROM "711_stores_df"') %>% group_by(city_name) %>% summarise(n=n())

library(tidyr)
titanic %>% group_by(survived, sex) %>% summarise(m=n()) %>%  spread(survived,m)
tw711 %>%  group_by(city_name, isATM) %>%  summarise(m=n()) %>%  spread(isATM,m)


# you will get some NA in value
# please note: only use 1 value in summarise
titanic %>% group_by(survived,sex) %>% 
  summarise(m=n(),avg_age=mean(age,na.rm = T)) %>% 
  spread(sex, avg_age)
# correct syntax
titanic %>% group_by(survived,sex) %>% 
  summarise(avg_age=mean(age,na.rm = T)) %>% 
  spread(sex, avg_age)

# use tidyrerse
install.packages("tidyverse")
library(tidyverse)


lottery_utf8 <- lottery_utf8[c(2,6:12)]
View(lottery_utf8)
names(lottery_utf8) <- c("Date", paste0("X",1:6), "S")
View(lottery_utf8)

# the following 2 statements are the same
lottery_utf8 %>% gather(key='ball', value=X, X1:S)
lottery_utf8 %>% gather(key='ball', value=X, -Date) 

# get the number of count of each ball
lottery_utf8 %>% gather(key='ball', value=X, -Date) %>% group_by(X)%>% summarise(count=n())
lottery_utf8 %>% gather(key='ball', value=X, -Date) %>% arrange(Date) %>% group_by(X) %>% summarise(count=n()) %>% ggplot(mapping = aes(x=X,y=count)) + geom_bar(stat="identity")


lottery_utf8 %>% gather(key = Ball, value = X, X1:S) %>% arrange(Date) %>% View

# the following 2 statements are the same
tw711_s <- tw711[c(1,11:32)] 
tw711_s %>% select(Address, is7WiFi:isUnionPay) %>%  View

tw711_s %>% gather(key=facility, value=isExist, -Address) %>% arrange(Address)%>%  View
