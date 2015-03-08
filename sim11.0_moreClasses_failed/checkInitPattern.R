rm (list = ls())
getwd()
tempVer = read.table("initVer.txt")
tempVis = read.table("initVis.txt")

image(as.matrix(tempVer[,2:length(tempVer)]))
image(as.matrix(tempVis[,2:length(tempVis)]))

nVer = length(tempVer)
nVis = length(tempVis)

# reformat the data
dataVer = as.matrix(tempVer[,2:nVer])
row.names(dataVer) = tempVer[,1]

dataVis = as.matrix(tempVis[,2:nVis])
row.names(dataVis) = tempVis[,1]

# visualization 
plot.new()
par(mfrow=c(1,1))
plot(hclust(dist(dataVer)))
plot(hclust(dist(dataVis)))

