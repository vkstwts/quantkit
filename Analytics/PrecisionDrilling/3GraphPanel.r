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


layout(matrix(1:6, nrow=6), height=c(4,2.5,4,2.5,4,2.5))
chartSeries(PDS,layout=NULL)
chartSeries(PD,layout=NULL)
chartSeries(CADUSD,layout=NULL)


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

