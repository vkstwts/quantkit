#Copyright (c) <2010> <Nick Torenvliet>
#		
#Permission is hereby granted, free of charge, to any person
#obtaining a copy of this software and associated documentation
#files (the "Software"), to deal in the Software without
#restriction, including without limitation the rights to use,
#copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the
#Software is furnished to do so, subject to the following
#conditions:
#		
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#OTHER DEALINGS IN THE SOFTWARE.

#installed wordnet from ubuntu packages 
#so far Snowball tends to only work when R is run as root -- bummer dude. 

#if Ubuntu installed an R update... you'll need to reinstall the required packages
installTextMinerPackages <- function(){
	install.packages("rJava")
	install.packages("RWeka")
	install.packages("Snowball")
	install.packages("plotrix")
}

loadTextMinerLibraries <- function(){
	library(wordnet)
	library(plotrix)
	library(Snowball)
	library(RWeka)
	library(rJava)
	library(tm)
}

#should probably set the working directory here to soemthing given in a config file.
saveImageSysTime <- function(){
	date <- substr(as.character(Sys.time()),1,19)
	save.image(paste("./Images/",date,sep=""))
}

saveNamedImage <- function(name){
	date <- substr(as.character(Sys.time()),1,19)
	save.image(paste("./Images/",name,sep=""))
}


incrementalBuildCorpusDTM <- function(){
	#Swap out the old corpus, dtm and dir listing
	WSJ_LAST_CORPUS <- WSJ_CORPUS
	WSJ_LAST_DTM <- WSJ_DTM
	dirListingLast <- dirListing
	
	#Get the incremental add to the corpus and the associated dir listing
	WSJ_CORPUS <- Corpus(DirSource("../Corpus/Corpus"))
	dirListing <- list.files("../Corpus/Corpus")
	
	#Move the incremental add raw data to the archive
	system("mv ../Corpus/Corpus/* ../Corpus/Archive")
	
	#Add the dir listing to the meta tag as author for now... why? Because you can.
	#corpus <- meta(WSJ_CORPUS,tag="Author",type="local") <- dirListing 
		
	#process the corpus
	WSJ_CORPUS <- tm_map(WSJ_CORPUS,stripWhitespace)
	WSJ_CORPUS <- tm_map(WSJ_CORPUS,tolower)
	WSJ_CORPUS <- tm_map(WSJ_CORPUS,removeWords,stopwords("english"))
	#WSJ_CORPUS <- tm_map(WSJ_CORPUS,removeNumbers) You may want to leave numbers depending on what findAssoc() can do for you.
	WSJ_CORPUS <- tm_map(WSJ_CORPUS,stemDocument)
	 
	myStopWords <- c("ms.", "dr.") #Add to the list of annoying words as required
	WSJ_CORPUS <- tm_map(WSJ_CORPUS,removeWords,myStopWords)
	WSJ_CORPUS <- tm_map(WSJ_CORPUS,removePunctuation)
	WSJ_DTM <- DocumentTermMatrix(WSJ_CORPUS)
	
	#Concatenate all persistent objects
	WSJ_CORPUS <- c(WSJ_LAST_CORPUS,WSJ_CORPUS)
	WSJ_DTM <- c.(t(WSJ_LAST_DTM),t(WSJ_DTM))
	WSJ_DTM <- t(WSJ_DTM)
	dirListing <- c(dirListingLast,dirListing)
}

#Time for some analysis
findFreqTerms(WSJ_DTM,5)

#When everything is done and you want to remove some more annoying stopwords -- remember to copy this list to the usage of removeWords above. 
myStopWords <- c("ms.", "dr.") #Add to the list of annoying words as required
WSJ_CORPUS <- tm_map(WSJ_CORPUS,removeWords,myStopWords)
WSJ_DTM <- DocumentTermMatrix(WSJ_CORPUS)

#Greek Debt Cr
(GreekDebtCrisis <- Dictionary(c("greece", "greec", "greek")))
myGreekDebtCrisisStudy <- inspect(DocumentTermMatrix(WSJ_CORPUS, list(dictionary = GreekDebtCrisis)))
matplot(myGreekDebtCrisisStudy)
matplot(myGreekDebtCrisisStudy, type= "l", xlab = "Length", ylab = "Width",main = "myStudy")
rownames(myGreekDebtCrisisStudy) <- substring(dirListing,1,8)

#some word study plots
(tech <- Dictionary(c("fujitsu", "apple", "goog","microsoft","amazon","barclay")))
mytechStudy <- inspect(DocumentTermMatrix(WSJ_CORPUS, list(dictionary = tech)))
rownames(mytechStudy) <- substring(dirListing,1,8)
matplot(mytechStudy,type="l", ylab="Word Frequency",col=c(26,36,46,51,114,115),lty=1,xaxt="n")
axis(1,at=1:95,label=rownames(mytechStudy),tick=TRUE)
legend(10,600,colnames(mytechStudy),col=c(26,36,46,51,114,115),lty=1)





