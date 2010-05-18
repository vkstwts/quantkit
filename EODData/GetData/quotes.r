#run from within R as "source("../path/quotes.r")

ncftpReturn <- system("../GetData/getEODData.sh 2>&1",intern=TRUE)
setwd("~/quantkit/EODData/Data")
dirListing <- list.files(".")
if (length(dirListing)>0){
	library(RMySQL)
	drv <- dbDriver("MySQL")
	con <- dbConnect(drv, host="localhost", dbname="markets", user="rootOrYourPreferredMySQLUser", pass="yourMySQLUserPassWord")
	for(x in 1:length(dirListing)){
		if(dirListing[x] != "Software" && dirListing[x] != "History" && dirListing[x] != "Archive" ){
			fileLines <- read.csv(dirListing[x],header = FALSE,row.names = NULL )
			string <- strsplit(dirListing[x], "_", fixed = TRUE)
			string <- string[[1]][1]
			for (j in 1:length(fileLines[,1])){
				sql <- paste("insert into endOfDayData (date,market,symbol,open,high,low,close,volume) values ('", fileLines[j,2],"','",string,"','",as.character(fileLines[j,1]),"','",fileLines[j,3],"','",fileLines[j,4],"','",fileLines[j,5],"','",fileLines[j,6],"','",fileLines[j,7],"')",sep="")
		#print(sql)	
				atmpt <- try(dbGetQuery(con,sql))
				options(show.error.messages = TRUE)
				if(inherits(atmpt, "try-error")){
				}
			}
			myCommand <- paste("mv ",dirListing[x]," History")
			system(myCommand)
		}
	}
	dbDisconnect(con)
}

