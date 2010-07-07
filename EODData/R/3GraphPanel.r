#install.packages("quantmod")
library(RMySQL)
library(quantmod)
drv = dbDriver("MySQL")

myHost <- "localhost"
myDb   <- "markets"
myUser <- "root"
myPass <- ""
market <- "NYSE"
symbol <- "PDS"
myFrom <- "2010-03-02"

con = dbConnect(drv, host=myHost, dbname=myDb, user=myUser, pass=myPass)
sql = paste("select date, open, high, low, close, volume from endOfDayData where date>'",myFrom,"' and market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
table <- dbGetQuery(con, statement=sql)
newTable <- xts(table[,-1],order.by=as.POSIXct(table[,1]))
cp <- newTable[,4]
closingPrice <- newTable[,4]
volume <- newTable[,5]
cumVolume <- cumsum(volume)
cor(cumVolume[1:length(newTable),],closingPrice[1:length(newTable),])
diffVolume <- diff(volume)
par(mfrow=c(3,1))
plot(closingPrice[1:length(cumVolume)],main=paste(symbol,"@",market," Closing Price",sep=""))
cor(cumVolume[1:length(cumVolume),],closingPrice[1:length(cumVolume),])
plot(cumVolume[1:length(cumVolume)],main=paste(symbol,"@",market," Cumulative Volume",sep=""))
plot(diffVolume[1:length(cumVolume)],main=paste(symbol,"@",market," First Order Differential Volume",sep=""))

#dev2bitmap("./BCS.pdf",type="pdfwrite")
