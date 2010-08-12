library(quantmod)
library(IBrokers)
tws <- twsConnect()
optionContracts <- reqContractDetails(tws, twsOption(local="", right="P", symbol="AAPL"))
optionData <-  reqHistoricalData(conn = tws, Contract = optionContracts[[1]]$contract,barSize = "30 mins",duration = "20 D",whatToShow = "ASK")
twsDisconnect(tws)
tws <- twsConnect()
equityContracts <- reqContractDetails(tws, twsEquity("AAPL"))
equityData <-  reqHistoricalData(conn = tws, Contract = equityContracts[[1]]$contract,barSize = "30 mins",duration = "20 D",whatToShow = "ASK")

layout(matrix(c(1,2), 2, 1, byrow = TRUE))
chartSeries(INTCTable,layout=NULL,TA=NULL)
chartSeries(CSCOTable,layout=NULL,TA=NULL)

layout(matrix(c(1,2), 2, 1, byrow = TRUE))
lineChart(equityData,layout=NULL,TA=NULL)
lineChart(optionData,layout=NULL,TA=NULL)

#Four charts with volume
getSymbols("SPY;DIA;QQQQ;IWM")
layout(matrix(1:8, nrow=4), height=c(4,2.5,4,2.5))
chartSeries(IWM, layout=NULL)
chartSeries(SPY, layout=NULL)
chartSeries(DIA, layout=NULL)
chartSeries(QQQQ, layout=NULL)

#Two charts with volume
getSymbols("INTC;CSCO")
layout(matrix(1:4, nrow=4), height=c(4,2.5,4,2.5))
chartSeries(INTC,layout=NULL)
chartSeries(CSCO,layout=NULL)
