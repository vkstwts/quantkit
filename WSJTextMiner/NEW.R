# TODO: Add comment
# 
# Author: torenvln
###############################################################################
setwd("~/quantkit/WSJTextMiner/Data")
library(wordnet)
library(Snowball)
library(RWeka)
library(rJava)
library(tm)
#setwd("Data")
dirListing <- list.files(".")
if (length(dirListing)>0){
	for(x in 1:length(dirListing)){
			setwd(dirListing[x])
			fileName <- paste(dirListing[1],".txt",sep="")
			doc <- c(fileName)
			corpus <- c(Corpus(VectorSource(doc)))
			setwd("..")
			print(dirListing[x])
			
	}
}


