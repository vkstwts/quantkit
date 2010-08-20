library(quantmod)
x <- read.csv('DJI.csv',header=TRUE)
x <- xts(x[,-1], order.by=as.POSIXct(x[,1]))

tsLo <- seq(1980+1/12,1995,1/12)
tsHi <- seq(1980+1/12,2010+8/12,1/12)
tsR  <- seq(2009+2/12,2010 + 8/12,1/12)
tsPredict <- seq(2009+2/12,2025,1/12)

loFit <- lm(x["1980::1994",4]~tsLo)
hiFit <- lm(x["1980::2010",4]~tsHi)hiFit <- lm(x["1980::2010",4]~tsHi)
tsRecovery2 <- tsRecovery^2
tsRecovery3 <- tsRecovery^3
tsRecovery4 <- tsRecovery^4
tsRecovery5 <- tsRecovery^5
rFit1 <- lm(x["200902::2010",4]~tsR)
rFit2 <- lm(x["200902::2010",4]~tsR + I(tsR^2))
rFit3 <- lm(x["200902::2010",4]~tsRecovery+I(tsRecovery^2)+I(tsRecovery^3))
rFit4 <- lm(x["200902::2010",4]~tsRecovery+I(tsRecovery^2)+I(tsRecovery^3)+I(tsRecovery^4))
rFit5 <- lm(x["200902::2010",4]~tsRecovery+I(tsRecovery^2)+I(tsRecovery^3)+I(tsRecovery^4)+I(tsRecovery^5))
ssr1 <- predict(rFit1,list(tsRecovery=tsRecovery))
ssr2 <- predict(rFit2,list(tsRecovery=tsRecovery))
ssr3 <- predict(rFit3,list(tsRecovery=tsRecovery))
ssr4 <- predict(rFit4,list(tsRecovery=tsRecovery))
ssr5 <- predict(rFit5,list(tsRecovery=tsRecovery))
plot(ssr1)
lines(ssr2)
lines(ssr3)
lines(ssr4)
lines(ssr5)


startMonth <- as.POSIXct(as.Date("01/01/1980", format="%d/%m/%Y"))
endMonth <- as.POSIXct(as.Date("01/01/2026", format="%d/%m/%Y"))

t6 <- seq(1980,2025,length = 46*12)

predictedLo <- timeBasedSeq('198001/202512')
predictedLo <- as.xts(predictedLo)
predictedLo <- cbind(predictedLo,0)
predictedHi <- timeBasedSeq('198001/202512')
predictedHi <- as.xts(predictedHi)
predictedHi <- cbind(predictedHi,0)
predictedRecovery <- timeBasedSeq('200902/202512')
predictedRecovery <- as.xts(predictedRecovery)


predictedHi[,1] <- coef(hiFit)[1] + t6*coef(hiFit)[2]
predictedLo[,1] <- coef(loFit)[1] + t6*coef(loFit)[2] 

plot(predictedHi,main="Square Root Recovery")
lines(predictedLo)
lines((predictedLo+predictedHi)/2)
lines(x[,4])

#x[965-length(x[,4])] has the data for the poly fit

#the following is based on the formula that the spreadsheet fit to the data, the initial values of the a/b/c params lead to errors on some kind of iterative search. 
nls(x["200902::2010", 4] ~ a + b * log(tsR-c) ,start=list(a=150,b=100,c=100),trace=TRUE)
# some help on http://stackoverflow.com/questions/2243046/curve-fitting-in-r-using-nls  search on "curve fitting in R"


#plot(x["1980::2010",4],main="Closing",xlim=c(startMonth,endMonth))
#plot(x["1980::2010",4],main="Closing",xlim=c(startMonth,endMonth))
#candleChart(x["1980::2010"], multi.col=TRUE,theme="white")
#plot(diff(x["1980::2010",4]),main="Closing")
#plot(diff(x["1980::2010",5]),main="Volume")
