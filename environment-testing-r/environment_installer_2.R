pkg_list <- c("magrittr", "dplyr", "tidyr", "data.table", "ggplot2",
              "readr", "lubridate", "extrafont", "ggrepel",
              "rmarkdown", "shiny", "knitr", "prettydoc", "plotly", "DT","mclust","fpc")
pkg_new <- pkg_list[!(pkg_list %in% installed.packages()[,"Package"])]
if(length(pkg_new)) install.packages(pkg_new)
rm(pkg_new, pkg_list)
