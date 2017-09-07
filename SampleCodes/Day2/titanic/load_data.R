library(readr)
titanic <- read_csv("https://raw.githubusercontent.com/haven-jeon/introduction_to_most_usable_pkgs_in_project/master/bicdata/data/titanic.csv",
col_types = cols(survived = col_character()))
