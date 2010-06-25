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

#if Ubuntu installed an R update... you'll need to reinstall the required packages
installTextMinerPackages <- function(){
	install.packages("rJava")
	install.packages("RWeka")
	install.packages("Snowball")
	install.packages("plotrix")
	install.packages("openNLP")
}

saveImageSysTime <- function(){
	date <- substr(as.character(Sys.time()),1,19)
	save.image(paste("./Images/",date,sep=""))
}

saveNamedImage <- function(name){
	save.image(paste("./Images/",name,sep=""))
}

print("*loading required libraries")
library(wordnet)
library(plotrix)
library(Snowball)
library(RWeka)
library(rJava)
library(tm)
library(openNLP)
	
#Swap out the old corpus, dtm and dir listing
print("*swapping old persistents into temporary buffers")
if(exists("ECONOMIST_RAW_CORPUS")){
	ECONOMIST_LAST_RAW_CORPUS <- ECONOMIST_RAW_CORPUS
}

if(exists("ECONOMIST_CORPUS")){
	ECONOMIST_LAST_CORPUS <- ECONOMIST_CORPUS
}

if(exists("ECONOMIST_DTM")){
	ECONOMIST_LAST_DTM <- ECONOMIST_DTM
}

if(exists("dirListing")){
	dirListingLast <- dirListing
}

#Get the incremental add to the corpus and the associated dir listing
print("*getting the new corpus elements")
ECONOMIST_CORPUS <- Corpus(DirSource("../Corpus/Corpus"))
ECONOMIST_RAW_CORPUS <- ECONOMIST_CORPUS
dirListing <- list.files("../Corpus/Corpus")

#Move the incremental add raw data to the archive
system("mv ../Corpus/Corpus/* ../Corpus/Archive")

#Add some meta tags if yo want
#corpus <- meta(ECONOMIST_CORPUS,tag="Author",type="local") <- dirListing 
	
#process the corpus
print("*processing the new corpus elements - stripping whitespace")
ECONOMIST_CORPUS <- tm_map(ECONOMIST_CORPUS,stripWhitespace)
print("*processing the new corpus elements - converting to lower case")
ECONOMIST_CORPUS <- tm_map(ECONOMIST_CORPUS,tolower)
print("*processing the new corpus elements - removing stopwords")
ECONOMIST_CORPUS <- tm_map(ECONOMIST_CORPUS,removeWords,stopwords("english"))
#ECONOMIST_CORPUS <- tm_map(ECONOMIST_CORPUS,removeNumbers) You may want to leave numbers depending on what findAssoc() can do for you.
#myStopWords <- c("ms.", "dr.") #Add to the list of annoying words as required
#ECONOMIST_CORPUS <- tm_map(ECONOMIST_CORPUS,removeWords,myStopWords)
print("*processing the new corpus elements - removing punctuation")
ECONOMIST_CORPUS <- tm_map(ECONOMIST_CORPUS,removePunctuation)
#ECONOMIST_CORPUS <- tm_map(ECONOMIST_CORPUS,stemDocument)
print("*processing the new corpus elements - ngram tokenizing")
ECONOMIST_DTM <- DocumentTermMatrix(ECONOMIST_CORPUS,control=list(tokenize=NGramTokenizer))
# Weka tokenizer -- NGRAMMAR <-TermDocumentMatrix(ECONOMIST_CORPUS,control=list(tokenize=NGramTokenizer))
# openNLP tokenizer 			> TermDocMatrix(col, control = list(tokenize = tokenize))
# openNLP sentence detection 	> TermDocMatrix(col, control = list(tokenize = sentDetect))
# Not sure if this worked NGRAMMAR <-TermDocumentMatrix(ECONOMIST_CORPUS,control=list(tokenize=NGramTokenizer,min=1,max=6))
# see page 35 of Ingo's thesis. 

#Concatenate all persistent objects
print("*concatenating corpus and dtm elements")
if(exists("ECONOMIST_LAST_RAW_CORPUS")){
	ECONOMIST_RAW_CORPUS <- c(ECONOMIST_LAST_RAW_CORPUS,ECONOMIST_RAW_CORPUS)	
}

if(exists("ECONOMIST_LAST_CORPUS")){
	ECONOMIST_CORPUS <- c(ECONOMIST_LAST_CORPUS,ECONOMIST_CORPUS)	
}

if(exists("ECONOMIST_LAST_DTM")){
	ECONOMIST_DTM <- c(t(ECONOMIST_LAST_DTM),t(ECONOMIST_DTM))
	ECONOMIST_DTM <- t(ECONOMIST_DTM)
}

if(exists("dirListingLast")){
	dirListing <- c(dirListingLast,dirListing)
}

print("*saving image")
date <- substr(as.character(Sys.time()),1,19)
save.image(paste("./Images/",date,sep=""))




