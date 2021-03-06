TAIFEX_RPT_DIR = Sys.getenv(x = "RPT_DIR", unset = "data/TAIFEX/rpt", names = NA)
TAIFEX_ZIP_DIR = Sys.getenv(x = "ZIP_DIR", unset = "data/TAIFEX/zip", names = NA)
TAIFEX_DB_FILE = Sys.getenv(x = "DB_PATH", unset = "data/TAIFEX/TaifexDaily.sqlite", names = NA)

TAIFEX_F_TbyT_ZIPs_URL = "http://www.taifex.com.tw/eng/eng3/eng3_1_3.asp"
TAIFEX_FC_TbyT_ZIPs_URL = "http://www.taifex.com.tw/eng/eng3/eng3_1_5.asp"


dir.create(TAIFEX_RPT_DIR,recursive = T)
dir.create(TAIFEX_ZIP_DIR,recursive = T)


library(quantmod)
library(httr)
library(rvest)
library(stringr)
library(RSQLite)


res = GET(TAIFEX_F_TbyT_ZIPs_URL)
downloadUrls = html(res) %>% html_nodes(".table_c input") %>% html_attr("onclick")
downloadUrls = sapply(downloadUrls,function(xx) str_replace_all(xx,"window.open[(]'../..","http://www.taifex.com.tw"))
downloadUrls = sapply(downloadUrls,function(xx) str_replace_all(xx,"'[)]",""))
names(downloadUrls) = NULL

downloadUrls = downloadUrls[grep("DataInformation.doc",downloadUrls,invert = T)]

downloadFilenames = sapply(downloadUrls, function(url){
  xx = unlist(strsplit(url,"/"))
  xx[length(xx)]
})
names(downloadFilenames) = NULL

dnFilesDF = data.frame(url=downloadUrls,dest=downloadFilenames,stringsAsFactors = F)
dnFilesDF$dest = sprintf("./%s/%s",TAIFEX_ZIP_DIR,dnFilesDF$dest)

rptFiles = apply(dnFilesDF,1,function(xx){
  do.call(download.file,as.list(xx))
  unzip(xx[2], exdir = sprintf("./%s/",TAIFEX_RPT_DIR))
})

library(magrittr)
rptFiles = rptFiles[grep("csv$",rptFiles)]

for (rptF in rptFiles){
  dataDate = rptF %>% str_replace_all("./data/TAIFEX/rpt//Daily_","") %>% str_replace_all(".csv","") %>% str_replace_all("_","")
  parsingRPT = F
  
  sqliteDrv <- dbDriver("SQLite")
  conn <- dbConnect(sqliteDrv,TAIFEX_DB_FILE)
  
  if (!"FutureTByT" %in% dbListTables(conn)){
    parsingRPT = T
  }else{
    if (dbGetQuery(conn,sprintf("select count(*) from FutureTByT where date = %s", dataDate))[1] == 0){
      parsingRPT = T
    }
  }
  
  if (parsingRPT){
    TaifexFutureTByT_df = read.csv(rptF, na.strings = "-",stringsAsFactors=FALSE)  
    TaifexFutureTByT_df$Time.of.Trades = sapply(TaifexFutureTByT_df$Time.of.Trades,function(time){
      ifelse(str_length(time) < 6,sprintf("0%s",time),time)
    })
    
    TaifexFutureTByT_df$Time = apply(TaifexFutureTByT_df,1,function(row){
      str_replace_all(paste(row[1],row[4],collapse = "")," ","")
    })
    
    TaifexFutureTByT_df$Time = strptime(TaifexFutureTByT_df$Time,"%Y%m%d%H%M%S",tz = "CST")
    
    filterd_idx = which(TaifexFutureTByT_df$Date!="\032")
    TaifexFutureTByT_df = TaifexFutureTByT_df[filterd_idx, ]
    #   dataDate = unique(TaifexFutureTByT_df$Date)
    
    rowData = data.frame(date = dataDate,
                         time = TaifexFutureTByT_df$Time,
                         price = TaifexFutureTByT_df$Trade.Price, 
                         pcode = str_replace_all(TaifexFutureTByT_df$Product.Code," ",""),
                         exMW = str_replace_all(TaifexFutureTByT_df$Contract.Month.Week.," ",""),
                         volume=TaifexFutureTByT_df$Volume.Buy.Sell./2,
                         pNM = TaifexFutureTByT_df$Price.for.Nearer.Delivery.Month.Contract,
                         pFM = TaifexFutureTByT_df$Price.for.Nearer.Delivery.Month.Contract,
                         OCA = TaifexFutureTByT_df$Opening.Call.Auction,                     
                         stringsAsFactors = F)
    
    dbWriteTable(conn, "FutureTByT", rowData,row.names=FALSE,append=TRUE)   
  }
  
  dbDisconnect(conn)
  print(sprintf("Finished Convert Data from %s into DB", rptF))
}
