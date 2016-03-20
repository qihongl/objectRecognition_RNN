rm(list = ls()); dev.off()
setwd('/Users/Qihong/Dropbox/github/categorization_PDP/mdsDynamics')
# set parameters
nObjs = 8        # number of distinct objects of interest 
nQs = 4 * nObjs  # number of possible questions that you can ask to the model

# read data
fullData <- read.table("dev.acts", header = FALSE, stringsAsFactors = FALSE)
fullData[1:nObjs,2]

# read parameter from data
firstUnitIdx = 4                    # the 4th colum <-> 1st hidden unit activation
nTimePts = dim(fullData)[1]/nQs     # num time points

# get names
patnames <- fullData[1:nObjs, 2]
for (i in 1:length(patnames)) {
    fullDataSplit = strsplit(patnames[i],'_')
    patnames[i] = fullDataSplit[[1]][1]
}
patnames # print pattern name
# -----------------------------------------------------------------------------
timeActData <- as.matrix(fullData[, firstUnitIdx:dim(fullData)[2] ] )
m = dim(timeActData)[1]     # num rows 
n = dim(timeActData)[2]     # num columns = num hidden units

# A HELPER FUNCTION
# given the time point, compute which rows corresponds to the objects of interest (nObjs) 
time_point_rows <- function(time_point = 0) {
    time_point * nQs + 1:nObjs
}
time_point_rows(4)
# get distance matrix for the 1st time pt
distMat_t0 <- as.matrix(dist(timeActData[1:nObjs, ]))
distMat_t4 <- as.matrix(dist(timeActData[time_point_rows(4), ]))
distMat_t29 <- as.matrix(dist(timeActData[time_point_rows(29), ]))
image(distMat_t4[8:1, ], zlim = c(0, 1.75), col = cm.colors(10))
image(distMat_t29[8:1, ], zlim = c(0, 1.75), col = cm.colors(10))

plot(hclust(as.dist(distMat_t0)), labels = patnames)
plot(hclust(as.dist(distMat_t4)), labels = patnames)
plot(hclust(as.dist(distMat_t29)), labels = patnames)

plot(cmdscale(as.dist(distMat_t0)), ylim = c(-1,1), xlim = c(-1, 1))
plot(cmdscale(as.dist(distMat_t4)), ylim = c(-1,1), xlim = c(-1, 1))
plot(cmdscale(as.dist(distMat_t29)), ylim = c(-1,1), xlim = c(-1, 1))
# problem: no reason for MDS solutions retain stable axes across time pts

all_scales <- cmdscale(dist(timeActData))

# create a panel with appropriate size
plot(0, 0, type = "n", ylim = range(all_scales), xlim = range(all_scales))

# lines(all_scales[0:29 * nQs + 1, ]) # first item at each of the snapshots in time

for (item_num in 1:8) 
    lines(all_scales[0:29 * nQs + item_num, ])

plot(0, 0, type = "n", ylim = range(all_scales), xlim = range(all_scales))
for (item_num in 1:8) {
    lines(all_scales[1:29 * nQs + item_num, ])
    points(all_scales[1:29 * nQs + item_num, ])
}

points(all_scales[1:8, ], pch = 17)
text(all_scales[29 * nQs + 1:8, ], labels = patnames)
