library(quantmod)

x <- read.csv('DJI.csv',header=TRUE)
x <- xts(x[,-1], order.by=as.POSIXct(x[,1]))

tsLo <- seq(1980+1/12,1995,1/12)
tsHi <- seq(1980+1/12,2010+8/12,1/12)
tsR  <- seq(2009+2/12,2010 + 8/12,1/12)
tsP <- seq(2009+2/12,2026,1/12)
tsF <- seq(1980,2025,length = 46*12)

loFit <- lm(x["1980::1994",4]~tsLo)
hiFit <- lm(x["1980::2010",4]~tsHi)
#add the base clamp indicated by response from Peter on R Help list... 
reFit <- nls(x["200902::2010", 4] ~ A + B * log(tsR-C),start=c(A=10078.4,B=1358.67,C=2009.07))

predictedLo <- timeBasedSeq('198001/202512')
predictedLo <- as.xts(predictedLo)
predictedLo <- cbind(predictedLo,0)
predictedHi <- timeBasedSeq('198001/202512')
predictedHi <- as.xts(predictedHi)
predictedHi <- cbind(predictedHi,0)
predictedRecovery <- timeBasedSeq('200902/202512')
predictedRecovery <- as.xts(predictedRecovery)
predictedRecovery <- cbind(predictedRecovery,0)

predictedHi[,1] <- coef(hiFit)[1] + tsF*coef(hiFit)[2]
predictedLo[,1] <- coef(loFit)[1] + tsF*coef(loFit)[2] 
predictedRecovery[,1] <- coef(reFit)[1] + coef(reFit)[2] * log(tsP - coef(reFit)[3])

plot(predictedHi,main="Square Root Recovery")
lines(predictedLo)
lines((predictedLo+predictedHi)/2)
lines(x[,4])
lines(predictedRecovery)

brownianSim <- function(simSeries,sdWindow,sdSeed){
	if (sdWindow < 2) return(-1)
	brownian <- simSeries
	brownian2 <- simSeries
	stdxy <- sdSeed
	for (i in 2:length(brownian)){
		if (i >= sdWindow){
			stdxy <- sd(brownian[(i - sdWindow + 1):i])
			brownian[i,1]<- brownian[[i-1,1]] + brownian2[[i,1]] - brownian2[[i-1,1]] + rnorm(1,mean=0,sd=stdxy)
		}else{
			brownian[i,1]<- brownian[[i-1,1]] + brownian2[[i,1]] - brownian2[[i-1,1]] + rnorm(1,mean=0,sd=stdxy)
		}
	}
	return(brownian)
}
#running the sim with brownianSim(predictedRecovery,4,800) give some really unstable runs, but also some really clean authentic looking runs and 
#clear convergence of the mean to the expected line.  
myPrediction <- brownianSim(predictedRecovery,4,800) #,sd(x["200902::200905",4]))
lines(myPrediction)

#dev2bitmap("./DJI_Extrapolation_sdwindow4_initialsd800.pdf",type="pdfwrite")

