#install.packages("quantmod")
#WORKING 3PANEL GRAPH AND WORD STUDY WSJ

#WORKING 4PANEL GRAPH AND WORD STUDY ECONOMIST
library(RMySQL)
library(quantmod)
library(tm)

myHost <- "localhost"
myDb   <- "markets"
myUser <- "localHack"
myPass <- "localHackPass"
market <- "NASDAQ"
symbol <- "INTC"
myFrom <- "2000-02-05"
thisCorpus <- ECONOMIST_CORPUS
terms <- c("gas", "natural","oil")

#Sets up the DB Data
drv = dbDriver("MySQL")
con = dbConnect(drv, host=myHost, dbname=myDb, user=myUser, pass=myPass)
sql = paste("select date, open, high, low, close, volume from endOfDayData where date>'",myFrom,"' and market like '",market,"' and symbol like '",symbol,"' order by date",sep="")
table <- dbGetQuery(con, statement=sql)
newTable <- xts(table[,-1],order.by=as.POSIXct(table[,1]))

candleChartName = paste(symbol,"@",market,sep="")
candleChart(newTable,name=candleChartName)

addADX()		#	ADX	Welles Wilder's Directional Movement Indicator
addATR()		#	ATR	Average True Range
addBBands()		#	BBands	Bollinger Bands
addCCI()		#	CCI	Commodity Channel Index
addCMF()		#	CMF	Chaiken Money Flow
addCMO()		#	CMO	Chande Momentum Oscillator
addDEMA()		#	DEMA	Double Exponential Moving Average
addDPO()		#	DPO	Detrended Price Oscillator
addEMA()		#	EMA	Exponential Moving Average
addEnvelope()	#	N/A	Price Envelope
addEVWMA()		#	EVWMA	Exponential Volume Weigthed Moving Average
addExpiry()		#	N/A	Options and Futures Expiration
addMACD()		#	MACD	Moving Average Convergence Divergence
addMomentum()	#	momentum	Momentum
addROC()		#	ROC	Rate of Change
addRSI()		#	RSI	Relative Strength Indicator
addSAR()		#	SAR	Parabolic Stop and Reverse
addSMA()		#	SMA	Simple Moving Average
addSMI()		#	SMI	Stocastic Momentum Index
addTRIX()		#	TRIX	Triple Smoothed Exponential Oscillator
addVo()			#	N/A	Volume
addWMA()		#	WMA	Weighted Moving Average
addWPR()		#	WPR	Williams %R
addZLEMA()		#	ZLEMA	ZLEMA

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

