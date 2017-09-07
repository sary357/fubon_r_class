for stock in $(cat stocks.txt); do STOCK_ID=$stock Rscript.exe test-exe-getStockMajorData.R; done

