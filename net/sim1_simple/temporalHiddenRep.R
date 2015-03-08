rm(list = ls())

# load the data 
temp = read.csv("hiddenOutAll.txt")
tempMatrix = as.matrix(temp[,4:5])
# temporal analysis

head(temp)
length(temp)



