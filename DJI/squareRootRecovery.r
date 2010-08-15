library(quantmod)
x <- read.csv('DJI.csv',header=TRUE)
x <- xts(x[,-1], order.by=as.POSIXct(x[,1]))

tsLo <- seq(1980,1994,length = length(x["1980::1994",4]))
tsHi <- seq(1980,2010,length = length(x["1980::2010",4]))
tsSSR <- seq(2009,2010,length = length(x["2009::2010",4]))

loFit <- lm(x["1980::1994",4]~tsLo)
hiFit <- lm(x["1980::2010",4]~tsHi)

startMonth <- as.POSIXct(as.Date("01/01/1980", format="%d/%m/%Y"))
endMonth <- as.POSIXct(as.Date("01/01/2026", format="%d/%m/%Y"))

t6 <- seq(1980,2025,length = 46*12)

predictedLo <- timeBasedSeq('198001/202512')
predictedLo <- as.xts(predictedLo)
predictedLo <- cbind(predictedLo,0)
predictedHi <- timeBasedSeq('198001/202512')
predictedHi <- as.xts(predictedHi)
predictedHi <- cbind(predictedHi,0)


predictedHi[,1] <- coef(hiFit)[1] + t6*coef(hiFit)[2]
predictedLo[,1] <- coef(loFit)[1] + t6*coef(loFit)[2] 

plot(predictedHi,main="Square Root Recovery")
lines(predictedLo)
lines((predictedLo+predictedHi)/2)
lines(x[,4])

#plot(x["1980::2010",4],main="Closing",xlim=c(startMonth,endMonth))
#plot(x["1980::2010",4],main="Closing",xlim=c(startMonth,endMonth))
#candleChart(x["1980::2010"], multi.col=TRUE,theme="white")
#plot(diff(x["1980::2010",4]),main="Closing")
#plot(diff(x["1980::2010",5]),main="Volume")
