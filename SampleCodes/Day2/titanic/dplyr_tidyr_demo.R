library(readr)
titanic <- read_csv("https://raw.githubusercontent.com/haven-jeon/introduction_to_most_usable_pkgs_in_project/master/bicdata/data/titanic.csv",
                    col_types = cols(survived = col_character()))


library(magrittr)
library(dplyr)
library(tidyr)

# SELECT survived, count(*) FROM titanic group by survived
titanic %>% group_by(survived) %>% summarise(n())

# SELECT survived, count(*) as m FROM titanic group by survived
titanic %>% group_by(survived) %>% summarise(m=n())

# SELECT survived, sex, count(*) FROM titanic group by survived, sex
titanic %>% group_by(survived,sex) %>% summarise(n())


titanic %>% group_by(survived,sex) %>% summarise(m=n()) %>% 
  spread(sex,m)


titanic %>% group_by(survived,sex,pclass) %>% summarise(m=n()) %>% 
  spread(survived,m)
