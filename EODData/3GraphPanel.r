library(RMySQL)
library(quantmod)
#install.packages("quantmod")
drv = dbDriver("MySQL")

myHost <- "yourHost"
myDb <- "yourDB"
myUser <- "yourUser"
myPass <- "yourPassed"

market <- "NYSE"
symbol <- "BCS"
myFrom <- "2007-01-01"

con = dbConnect(drv, host=myHost, dbname=myDb, user=myUser, pass=myPass)
con = dbConnect(drv, host=myHost, dbname=myDb, user=myUser, pass=myPass)
market <- "NYSE"
symbol <- "BCS"
myFrom <- "2007-01-01"
sql = paste("select date, open, high, low, close, volume from endOfDayData where date>'",myFrom,"' and market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
sql = paste("select date, open, high, low, close, volume from endOfDayData where date>'",myFrom,"' and market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
table <- dbGetQuery(con, statement=sql)
newTable <- xts(table[,-1],order.by=as.POSIXct(table[,1]))
newTable <- xts(table[,-1],order.by=as.POSIXct(table[,1]))
cp <- newTable[,4]
closingPrice <- newTable[,4]
volume <- newTable[,5]
cumVolume <- cumsum(volume)
cor(cumVolume[1:851,],closingPrice[1:851,])
cor(cumVolume[1:851,],closingPrice[1:851,])
difVolume <- diff(volume)
diffVolume <- diff(volume)
par(mfrow=c(3,1))
plot(closingPrice[1:851],main="BCS Closing Price")
cor(cumVolume[1:851,],closingPrice[1:851,])
plot(cumVolume[1:851],main="BCS Cumulative Volume")
plot(diffVolume[1:851],main="BCS First Order Differential Volume")
diffVolume

#dev2bitmap("./BCS.pdf",type="pdfwrite")
