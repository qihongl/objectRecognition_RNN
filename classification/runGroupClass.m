%% run a bunch of classifier
% when simulating using random subset or normal noise, there is randomness
% so we need a sample to establish average
clear variables; clc;warning('off','all');
FILENAME.PROTOTYPE = 'PROTO.xlsx';
sampleSize = 20;
timePoints = 25;
propChoice = [.005 .01 .05 .15 .3];
optionChoice = {'randomSubset', 'spatBlurring'};
logParam.var = 0;

% 
saveData = 1;
showPlot = 0;

%% Specify the Path information (user needs to do this!)
PATH.PROJECT = '../';
FILENAME.DATA = 'hidden_normal_e20.txt';

% provide the NAMEs of the data files (user need to set them mannually)
simName = 'decay';
sim_idx = 27;
rep_idxs = 6 : 17

%% parameter for logistic regresison classifier
for rep_idx = rep_idxs
    PATH.DATA_FOLDER = sprintf('sim%d.%d_%s', sim_idx, rep_idx, simName); 
    groupMVPA(PATH, FILENAME, propChoice, optionChoice,logParam,...
        sampleSize,timePoints,saveData,showPlot)
end