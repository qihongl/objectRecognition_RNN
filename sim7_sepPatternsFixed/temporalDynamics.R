rm(list = ls())
getwd()
list.files()
temp = read.table("VerbalOut.txt")
temp2 = read.table("hiddenFinalOut.txt")
namingData = temp[temp[,1] > 21,]



