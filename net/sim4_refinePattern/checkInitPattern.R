rm (list = ls())
setwd("/Users/Qihong/Desktop/711PDP/net/sim5_refinePattern2")
temp = read.table("temp.txt")

# reformat the data
n = length(temp);
data = as.matrix(temp[,2:n])
row.names(data) = temp[,1]

# visualization 
plot(hclust(dist(data)))
