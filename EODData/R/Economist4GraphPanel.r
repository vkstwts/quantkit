#install.packages("quantmod")

#WORKING 4PANEL GRAPH AND WORD STUDY WSJ
library(RMySQL)
library(quantmod)
library(tm)
library(plotrix)

myHost <- "localhost"
myDb   <- "markets"
myUser <- "localHack"
myPass <- "localHackPass"
market <- "NYSE"
symbol <- "AAPL"
myFrom <- "2010-03-02" #WSJ
thisCorpus <- WSJ_CORPUS

#myFrom <- "2010-02-04" #Economist
#thisCorpus <- ECONOMIST_CORPUS

terms <- c("aaple", "aapl","iphone")

#Sets up the DB Data
drv = dbDriver("MySQL")
con = dbConnect(drv, host=myHost, dbname=myDb, user=myUser, pass=myPass)
sql = paste("select date, open, high, low, close, volume from endOfDayData where date>'",myFrom,"' and market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
table <- dbGetQuery(con, statement=sql)
newTable <- xts(table[,-1],order.by=as.POSIXct(table[,1]))
cp <- newTable[,4]
closingPrice <- newTable[,4]
volume <- newTable[,5]
cumVolume <- cumsum(volume)
diffVolume <- diff(volume)
dict <- Dictionary(terms)
dictStudy <- inspect(DocumentTermMatrix(thisCorpus, list(dictionary = dict)))
rownames(dictStudy) <- substring(dirListing,1,8)
colours <- c("blue","red","forestgreen","hotpink","purple","cyan","black","gray57","greenyellow","yellow","aquamarine")
par(mfrow=c(4,1))
plot(closingPrice[1:length(cumVolume)],main=paste(symbol,"@",market," Closing Price",sep=""))
cor(cumVolume[1:length(cumVolume),],closingPrice[1:length(cumVolume),])
plot(cumVolume[1:length(cumVolume)],main=paste(symbol,"@",market," Cumulative Volume",sep=""))
plot(diffVolume[1:length(cumVolume)],main=paste(symbol,"@",market," First Order Differential Volume",sep=""))
matplot(dictStudy,type="l", ylab="Word Frequency",col=colours,lty=1,xaxt="n",main=paste("Frequency of terms in the Wall Street Journal",sep=" "))
rowname_index<-seq(1,length(rownames(dictStudy)),by=5)
axis(1,rowname_index,labels=rep("",20))
staxlab(1,rowname_index,labels=rownames(dictStudy)[rowname_index],srt=45)
legend(0.5,(max(dictStudy)-10),colnames(dictStudy),col=colours,lty=1, cex=0.8,ncol=length(terms))


#WORKING 4PANEL GRAPH AND WORD STUDY ECONOMIST
#library(RMySQL)
#library(quantmod)
#library(tm)
#
#myHost <- "localhost"
#myDb   <- "markets"
#myUser <- "localHack"
#myPass <- "localHackPass"
#market <- "TSX"
#symbol <- "PD"
#myFrom <- "2010-02-05"
#thisCorpus <- ECONOMIST_CORPUS
#terms <- c("gas", "natural","oil")
#
##Sets up the DB Data
#drv = dbDriver("MySQL")
#con = dbConnect(drv, host=myHost, dbname=myDb, user=myUser, pass=myPass)
#sql = paste("select date, open, high, low, close, volume from endOfDayData where date>'",myFrom,"' and market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
#table <- dbGetQuery(con, statement=sql)
#newTable <- xts(table[,-1],order.by=as.POSIXct(table[,1]))
#cp <- newTable[,4]
#closingPrice <- newTable[,4]
#volume <- newTable[,5]
#cumVolume <- cumsum(volume)
#diffVolume <- diff(volume)
#dict <- Dictionary(terms)
#dictStudy <- inspect(DocumentTermMatrix(thisCorpus, list(dictionary = dict)))
#dirListing <- list.files("../Data/Archive")
#rownames(dictStudy) <- paste(substring(dirListing,1,4),"-",substring(dirListing,5,6),"-",substring(dirListing,7,8),sep="")
#labels<-(as.POSIXlt(rownames(dictStudy))+172800)
#labels<-format.POSIXct(labels,format="%Y-%m-%d")
#dictStudy <- xts (dictStudy,order.by=as.POSIXct(labels))
#
#colours <- c("blue","red","forestgreen","hotpink","purple","cyan","black","gray57","greenyellow","yellow","aquamarine")
#par(mfrow=c(4,1))
#plot(closingPrice[1:length(cumVolume)],main=paste(symbol,"@",market," Closing Price",sep=""))
#plot(cumVolume[1:length(cumVolume)],main=paste(symbol,"@",market," Cumulative Volume",sep=""))
#plot(diffVolume[1:length(cumVolume)],main=paste(symbol,"@",market," First Order Differential Volume",sep=""))
#matplot(dictStudy[1:(length(dictStudy)/3)],type="l",xaxt="n",col=colours,lty=1,main=paste("Frequency of terms in the Economist",sep=" "),ylab="")
#axis(1, at = 1:length(labels), labels = labels, cex.axis = 0.7)
#legend(0.5,(max(dictStudy)-10),colnames(dictStudy),col=colours,lty=1)


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

