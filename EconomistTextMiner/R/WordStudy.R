# TODO: Add comment
# 
# Author: torenvln
###############################################################################


#some word study plots
thisCorpus <- WSJ_CORPUS
terms <- c("precision", "drilling","shale","fracking","fracing","gas")

dict <- Dictionary(terms)
dictStudy <- inspect(DocumentTermMatrix(thisCorpus, list(dictionary = dict)))
rownames(dictStudy) <- substring(dirListing,1,8)
colours <- c("blue","red","forestgreen","hotpink","purple","cyan","black","gray57","greenyellow","yellow","aquamarine")

#matplot(dictStudy,type="l", ylab="Word Frequency",col=colours,lty=1,xaxt="n")
#axis(1,at=1:length(dirListing),label=rownames(dictStudy),tick=TRUE,las=1)
#legend(10,(max(dictStudy)-10),colnames(dictStudy),col=colours,lty=1)

#nice looking graph
library(plotrix)
matplot(dictStudy,type="l", ylab="Word Frequency",col=colours,lty=1,xaxt="n")
rowname_index<-seq(1,length(rownames(dictStudy)),by=5)
axis(1,rowname_index,labels=rep("",20))
staxlab(1,rowname_index,labels=rownames(dictStudy)[rowname_index],srt=45)
legend(10,(max(dictStudy)-10),colnames(dictStudy),col=colours,lty=1)