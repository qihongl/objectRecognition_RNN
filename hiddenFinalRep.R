rm(list = ls())
library(ggplot2)
library(ggdendro)
PROJECT_DIR = '/Users/Qihong/Dropbox/github/PDPmodel_Categorization'

# you need to enter the file name and folder name here!
DATA_FOLDER = 'sim19_twoClasses'
FILENAME = 'hiddenFinal_e2.txt'

# load the data 
datapath = paste(PROJECT_DIR, DATA_FOLDER, FILENAME, sep="/") 
temp = read.table(datapath)

# set some parameters
n = length(temp)
numPatterns = dim(temp)[1]


# convert the hidden activation to a matrix
hiddenData = as.matrix(temp[1:numPatterns,4:n])
temp = as.vector(temp[1:numPatterns,2])
temp = sapply(strsplit(temp, split='l', fixed=TRUE), function(x) (x[2]))
row.names(hiddenData) = temp


# Analysis for full data (verbal + visual)
# compute the dissimilarity structure 
plot.new()
par(mfrow = c(1,1))
distanceMatrix = (as.matrix(dist(hiddenData)))
image(distanceMatrix[numPatterns:1,], zlim = c(0,5.5), 
      col = heat.colors(10, 1), yaxt = "n", xaxt = "n")
# mtext(row.names(hiddenData)) 
plot.new()
lowerTriangularIndices = lower.tri(distanceMatrix)
range (distanceMatrix[lowerTriangularIndices])
image(distanceMatrix[numPatterns:1,], zlim = c(0,5.5), 
      col = heat.colors(10, 1), yaxt = "n", xaxt = "n")



# hclust
# par(mfrow = c(1,2))

par(mfrow = c(1,1))
plot(hclust(dist(hiddenData)), 
     main = 'Hierarchical clustering: hidden layer \nneural representations for all instances',
     xlab = 'instances', ylab = 'distance')

# hc <- hclust(dist(hiddenData), "ave")
# ggdendrogram(hc, rotate = FALSE, size = 2) + ggtitle("Hierarchical clustering: hidden layer \nneural representations for all instances")


# 2D MDS
hiddenMDS = cmdscale(distanceMatrix)
# check the range
range = max(abs(hiddenMDS));
plot(hiddenMDS, 
     main = 'MDS: hidden layer neural\n representations for all instances',
     xlab = 'distance', ylab = 'distance',type = 'n',
     xlim = c(-range,range), ylim = c(-range,range))
text(hiddenMDS,labels = row.names(hiddenData))



