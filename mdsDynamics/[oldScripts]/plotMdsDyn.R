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
all_scales <- cmdscale(dist(timeActData))

# create a panel with appropriate size
# plot(0, 0, type = "n", ylim = range(all_scales), xlim = range(all_scales))
# lines(all_scales[0:29 * nQs + 1, ]) # first item at each of the snapshots in time

# for (item_num in 1:8) 
#     lines(all_scales[0:29 * nQs + item_num, ])

plot(0, 0, type = "n", ylim = range(all_scales), xlim = range(all_scales))
for (item_num in 1:8) {
    lines(all_scales[0:29 * nQs + item_num, ])
    points(all_scales[0:29 * nQs + item_num, ], pch = 4)
}

points(all_scales[1:8, ], pch = 1)
text(all_scales[29 * nQs + 1:8, ], labels = patnames)
