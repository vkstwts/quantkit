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









