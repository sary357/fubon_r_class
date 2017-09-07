devtools::install_github("leoluyi/PTTr")

library(PTTr)
get_post_content("https://www.ptt.cc/bbs/Gossiping/M.1467117389.A.62D.html")
dt <- get_all_posts("Gossiping", max_post = 10)
