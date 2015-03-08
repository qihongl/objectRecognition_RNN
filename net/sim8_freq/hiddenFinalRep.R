rm(list = ls())
getwd()

# load the data
temp = read.table("hiddenOut_e3a005.txt")

# set some parameters
n = length(temp)
numPatterns = 12


# convert the hidden activation to a matrix
hiddenData = as.matrix(temp[22:33,4:n])
row.names(hiddenData) = temp[22:33,2]

# verbal animals bar plots
plot.new()
par(mfrow = c(3,4))
for (i in 1:12) {
    barplot(hiddenData[i,], beside = T)
    title(row.names(hiddenData)[i])
}


# Analysis for full data (verbal + visual)
# compute the dissimilarity structure 
plot.new()
par(mfrow = c(1,1))
distanceMatrix = (as.matrix(dist(hiddenData)))
image(distanceMatrix[12:1,], zlim = c(0,5.5), col = heat.colors(10, 1), yaxt = "n", xaxt = "n")
# mtext(row.names(hiddenData)) 
plot.new()
lowerTriangularIndices = lower.tri(distanceMatrix)
range (distanceMatrix[lowerTriangularIndices])
image(distanceMatrix[12:1,], zlim = c(0,5.5), col = heat.colors(10, 1), yaxt = "n", xaxt = "n")

# hclust
plot.new()
par(mfrow = c(1,1))
plot(hclust(dist(hiddenData)), 
     main = 'Hierarchical clustering for the representations \nfor different instances in the hidden layer',
     xlab = 'instances', ylab = 'distance')

# 2D MDS
hiddenMDS = cmdscale(distanceMatrix)
plot(hiddenMDS, 
     main = 'Similarity of representations \nfor different instances in the hidden layer',
     xlab = 'distance', ylab = 'distance', type = 'n',
     xlim = c(-2,2), ylim = c(-2,2))
text(hiddenMDS,labels = row.names(hiddenData))

