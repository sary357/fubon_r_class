library(readr)

titanic <- read_csv("https://raw.githubusercontent.com/haven-jeon/introduction_to_most_usable_pkgs_in_project/master/bicdata/data/titanic.csv",
col_types = cols(survived = col_character()))
View(titanic)

library(ggplot2)
library(magrittr)
ls()
titanic %>% ggplot(mapping=aes(x=pclass)) + geom_bar()

titanic %>% ggplot(mapping=aes(x=pclass, y=sex)) + geom_boxplot()
