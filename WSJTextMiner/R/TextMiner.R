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
	install.packages("openNLP")
}

loadTextMinerLibraries <- function(){
	library(wordnet)
	library(plotrix)
	library(Snowball)
	library(RWeka)
	library(rJava)
	library(tm)
	library(openNLP)
}

saveImageSysTime <- function(){
	date <- substr(as.character(Sys.time()),1,19)
	save.image(paste("./Images/",date,sep=""))
}

saveNamedImage <- function(name){
	save.image(paste("./Images/",name,sep=""))
}
	
#Swap out the old corpus, dtm and dir listing
if(exists("WSJ_RAW_CORPUS")){
	WSJ_LAST_RAW_CORPUS <- WSJ_RAW_CORPUS
}
if(exists("WSJ_CORPUS")){
	WSJ_LAST_CORPUS <- WSJ_CORPUS
}
if(exists("WSJ_DTM")){
	WSJ_LAST_DTM <- WSJ_DTM
}
if(exists("dirListing")){
	dirListingLast <- dirListing
}

#Get the incremental add to the corpus and the associated dir listing
WSJ_CORPUS <- Corpus(DirSource("../Corpus/Corpus"))
WSJ_RAW_CORPUS <- WSJ_CORPUS
dirListing <- list.files("../Corpus/Corpus")

#Move the incremental add raw data to the archive
system("mv ../Corpus/Corpus/* ../Corpus/Archive")

#Add some meta tags if yo want
#corpus <- meta(WSJ_CORPUS,tag="Author",type="local") <- dirListing 
	
#process the corpus
WSJ_CORPUS <- tm_map(WSJ_CORPUS,stripWhitespace)
WSJ_CORPUS <- tm_map(WSJ_CORPUS,tolower)
WSJ_CORPUS <- tm_map(WSJ_CORPUS,removeWords,stopwords("english"))
#WSJ_CORPUS <- tm_map(WSJ_CORPUS,removeNumbers) You may want to leave numbers depending on what findAssoc() can do for you.
#myStopWords <- c("ms.", "dr.") #Add to the list of annoying words as required
#WSJ_CORPUS <- tm_map(WSJ_CORPUS,removeWords,myStopWords)
WSJ_CORPUS <- tm_map(WSJ_CORPUS,removePunctuation)
#WSJ_CORPUS <- tm_map(WSJ_CORPUS,stemDocument) 
WSJ_DTM <- DocumentTermMatrix(WSJ_CORPUS)
# Weka tokenizer -- NGRAMMAR <-TermDocumentMatrix(WSJ_CORPUS,control=list(tokenize=NGramTokenizer))
# openNLP tokenizer 			> TermDocMatrix(col, control = list(tokenize = tokenize))
# openNLP sentence detection 	> TermDocMatrix(col, control = list(tokenize = sentDetect))
# Not sure if this worked NGRAMMAR <-TermDocumentMatrix(WSJ_CORPUS,control=list(tokenize=NGramTokenizer,min=1,max=6))
# see page 35 of Ingo's thesis. 

#Concatenate all persistent objects
if(exists("WSJ_LAST_RAW_CORPUS")){
	WSJ_RAW_CORPUS <- c(WSJ_LAST_RAW_CORPUS,WSJ_RAW_CORPUS)	
}
if(exists("WSJ_LAST_CORPUS")){
	WSJ_CORPUS <- c(WSJ_LAST_CORPUS,WSJ_CORPUS)	
}
if(exists("WSJ_LAST_DTM")){
	WSJ_DTM <- c(t(WSJ_LAST_DTM),t(WSJ_DTM))
	WSJ_DTM <- t(WSJ_DTM)
}
if(exists("dirListingLast")){
	dirListing <- c(dirListingLast,dirListing)
}





