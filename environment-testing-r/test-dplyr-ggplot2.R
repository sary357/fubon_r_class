library(readr)
titanic <- read_csv("https://raw.githubusercontent.com/haven-jeon/introduction_to_most_usable_pkgs_in_project/master/bicdata/data/titanic.csv",
                    col_types = cols(survived = col_character()))


library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)

dim(titanic)
titanic %>% dim

# select sex, count(*) as N from titanic group by sex
titanic %>% group_by(sex) %>% summarise(N=n())
summarise(group_by(titanic,sex),N=n())

# select sex, survived, count(*) as N from titanic group by sex, survived 
titanic %>% group_by(sex,survived) %>% summarise(N=n())

titanic %>% 
  ggplot(mapping = aes(x=sex)) + 
  geom_bar() + facet_grid(survived~pclass)


titanic %>% 
  ggplot(mapping = aes(x=sex,fill=survived)) + 
  geom_bar()
