library(RMySQL)
library(quantmod)
library(tm)

myHost <- "localhost"
myDb   <- "markets"
myUser <- "localHack"
myPass <- "localHackPass"

market <- "NYSE"
symbol <- "PDS"
drv = dbDriver("MySQL")
con = dbConnect(drv, host=myHost, dbname=myDb, user=myUser, pass=myPass)
sql = paste("select date, open, high, low, close, volume from endOfDayData where market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
table <- dbGetQuery(con, statement=sql)
PDS <- xts(table[,-1],order.by=as.POSIXct(table[,1]))

market <- "TSX"
symbol <- "PD"
sql = paste("select date, open, high, low, close, volume from endOfDayData where market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
table <- dbGetQuery(con, statement=sql)
PD <- xts(table[,-1],order.by=as.POSIXct(table[,1]))

market <- "FOREX"
symbol <- "CADUSD"
sql = paste("select date, open, high, low, close, volume from endOfDayData where market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
table <- dbGetQuery(con, statement=sql)
CADUSD <- xts(table[,-1],order.by=as.POSIXct(table[,1]))

market <- "NYMEX"
symbol <- "NG"
sql = paste("select date, open, high, low, close, volume from endOfDayData where market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
table <- dbGetQuery(con, statement=sql)
NG <- xts(table[,-1],order.by=as.POSIXct(table[,1]))


layout(matrix(1:8, nrow=8), height=c(4,2.5,4,2.5,4,2.5,4,2.5))
chartSeries(PDS['2010'],layout=NULL)
chartSeries(PD['2010'],layout=NULL)
chartSeries(CADUSD['2010'],layout=NULL)
chartSeries(NG['2010'],layout=NULL)

mean(PD[,4])
mean(PDS[,4])
mean(CADUSD[,4])
var(PD['2010',4])
var(PDS['2010',4])
var(CADUSD[,4])
#add some natural gas and oil related assets into this analysis. 

#SELECT distinct names.symbol,names.market,names.name from names where (names.symbol like "NG_09" or names.symbol like "NG_10" or names.symbol like "NG_11") and names.name like "%}%" order by names.symbol

#################################SCRATCH PAD####################################################
##correlation
#cor(cumVolume[1:length(cumVolume),],closingPrice[1:length(cumVolume),])
##Get a PDF of the output
#name = paste("./",symbol,".pdf",sep="")
#dev2bitmap("./BCS.pdf",type="pdfwrite")
##Some hacking at graphs
#matplot(dictStudy,type="l", ylab="Word Frequency",col=colours,lty=1,xaxt="n")
#axis(1,at=1:length(dirListing),label=rownames(dictStudy),tick=TRUE,las=1)
#legend(10,(max(dictStudy)-10),colnames(dictStudy),col=colours,lty=1)
##nice looking graph
#matplot(dictStudy,type="l", ylab="Word Frequency",col=colours,lty=1,xaxt="n",main=paste("Frequency of terms in the Wall Street Journal",sep=" "))
#rowname_index<-seq(1,length(rownames(dictStudy)),by=5)
#axis(1,rowname_index,labels=rep("",20))
#staxlab(1,rowname_index,labels=rownames(dictStudy)[rowname_index],srt=45)
#legend(10,(max(dictStudy)-10),colnames(dictStudy),col=colours,lty=1, cex=0.8)

