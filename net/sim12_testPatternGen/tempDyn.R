# remove all variables
rm(list = ls())
# set the directory
setwd("/Users/Qihong/Dropbox/Current/711PDP/net/sim12_testPatternGen")
# read the data
data = read.table("verbalRepOut_e1.txt")

# CONSTANTS
interval = 26;
numStimuli = dim(data)[1] / interval;

