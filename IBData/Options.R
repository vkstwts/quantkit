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
chartSeries(equityData,layout=NULL,TA=NULL)
chartSeries(optionData,layout=NULL,TA=NULL)

layout(matrix(c(1,2), 2, 1, byrow = TRUE))
lineChart(equityData,layout=NULL,TA=NULL)
lineChart(optionData,layout=NULL,TA=NULL)

