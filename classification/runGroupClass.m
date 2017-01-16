%% run a bunch of classifier
% when simulating using random subset or normal noise, there is randomness
% so we need a sample to establish average
clear variables; clc;
sampleSize = 20;
timePoints = 25;
saveData = 1;
showPlot = 0; 

%% Specify the Path information (user needs to do this!)
PATH.PROJECT = '../';
% PATH.DATA_FOLDER = 'sim22.1_RSVP';
PATH.DATA_FOLDER = 'sim27.6_decay';
% PATH.DATA_FOLDER = 'sim26.3_initCond';
% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'hidden_normal_e20.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%% parameter for logistic regresison classifier
% classOpt = classification options
propChoice = [.005 .01 .05 .15 .3];
optionChoice = {'randomSubset', 'spatBlurring'};
logParam.var = 0; 

groupMVPA(PATH, FILENAME, propChoice, optionChoice,logParam,...
    sampleSize,timePoints,saveData,showPlot)
%
datetime
