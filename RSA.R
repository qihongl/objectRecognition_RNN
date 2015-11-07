rm(list = ls())
source('myImagePlot.R')
PROJECT_DIR = '/Users/Qihong/Dropbox/github/categorization_PDP'

setwd(PROJECT_DIR)
# you need to enter the file name and folder name here!
DATA_FOLDER = 'sim16_large'
FILENAME = 'hiddenFinal_e3.txt'

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

RDM = matrix(data=NA, nrow=numPatterns, ncol=numPatterns)
for (i in 1 : numPatterns){
    for (j in 1 : numPatterns){
        RDM[i,j] = 1-cor(hiddenData[i,], hiddenData[j,])
    }
}
RDM
myImagePlot(RDM)
