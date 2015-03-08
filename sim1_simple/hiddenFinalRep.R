rm(list = ls())

# load the data
temp = read.table("hiddenOutFinal.txt")

# convert the hidden activation to a matrix
hiddenData = as.matrix(temp[,4:length(temp)])
row.names(hiddenData) = temp[,2]

# split the hidden activation for visual input and verbal input
verbalHidden = hiddenData[1:16,]
visualHidden = hiddenData[17:32,]


# verbal animals bar plots
plot.new()
par(mfrow = c(2,4))
for (i in 1:8) {
    barplot(hiddenData[i,], beside = T)
    title(row.names(hiddenData)[i])
}
# verbal 
# artifacts bar plots
plot.new()
par(mfrow = c(2,4))
for (i in 1:8) {
    barplot(hiddenData[i + 8,], beside = T)
    title(row.names(hiddenData)[i + 8])
}

# you can also plot visual bar plots
# ...


# Analysis for full data (verbal + visual)
# compute the dissimilarity structure 
plot.new()
par(mfrow = c(1,1))
distanceMatrix = (as.matrix(dist(hiddenData)))
image(distanceMatrix[16:1,], zlim = c(0,2), col = heat.colors(10, 1), yaxt = "n", xaxt = "n")
# mtext(row.names(hiddenData)) 
lowerTriangularIndices = lower.tri(distanceMatrix)
range (distanceMatrix[lowerTriangularIndices])
image(distanceMatrix[16:1,], zlim = c(0,3.5), col = heat.colors(10, 1), yaxt = "n", xaxt = "n")

# hclust
plot.new()
par(mfrow = c(1,1))
plot(hclust(dist(hiddenData)))

# 2D MDS
hiddenMDS = cmdscale(distanceMatrix)
plot(hiddenMDS)
text(hiddenMDS,labels = row.names(hiddenData))


## analysis for verbal data only
# compute the distance matrix 
distanceMatrix = (as.matrix(dist(verbalHidden)))

# heat plot 
plot.new()
par(mfrow = c(1,1))
image(distanceMatrix[16:1,], zlim = c(0,2), col = heat.colors(10, 1), yaxt = "n", xaxt = "n")
lowerTriangularIndices = lower.tri(distanceMatrix)
range (distanceMatrix[lowerTriangularIndices])
image(distanceMatrix[16:1,], zlim = c(0,3.5), col = heat.colors(10, 1), yaxt = "n", xaxt = "n")


# hclust
plot.new()
par(mfrow = c(1,1))
plot(hclust(dist(verbalHidden)))

# 2D MDS
hiddenMDS = cmdscale(distanceMatrix)
plot(hiddenMDS)
text(hiddenMDS,labels = row.names(hiddenData))



## analysis for verbal data only
# compute the distance matrix 
distanceMatrix = (as.matrix(dist(visualHidden)))

# heat plot 
plot.new()
par(mfrow = c(1,1))
image(distanceMatrix[16:1,], zlim = c(0,2), col = heat.colors(10, 1), yaxt = "n", xaxt = "n")
lowerTriangularIndices = lower.tri(distanceMatrix)
range (distanceMatrix[lowerTriangularIndices])
image(distanceMatrix[16:1,], zlim = c(0,3.5), col = heat.colors(10, 1), yaxt = "n", xaxt = "n")


# hclust
plot.new()
par(mfrow = c(1,1))
plot(hclust(dist(visualHidden)))

# 2D MDS
hiddenMDS = cmdscale(distanceMatrix)
plot(hiddenMDS)
text(hiddenMDS,labels = row.names(visualHidden))


