%% run a bunch of classifier
% when simulating using random subset or normal noise, there is randomness
% so we need a sample to establish average
clear variables; clc;warning ('off','all');
rng(1);
PATH.PROJECT = '../';
FILENAME.PROTOTYPE = 'PROTO.xlsx';
sampleSize = 20;
nTimePoints = 25;
propChoice = [.01 .025 .05 .1 .15];
optionChoice = {'randomSubset', 'spatBlurring'};
methodChoice = {'lasso','ridge', 'svm'};
saveData = 1;
showPlot = 0;

logParam.var = 0;
logParam.collapseTime = 0; 


%% Specify the Path information (user needs to do this!)
FILENAME.DATA = 'hidden_rapid_e20.txt';
simName = 'varyNoise';
sim_idx = 27;
sim_idxs_sub = [1];
rep_idxs = 0:2;

%% parameter for logistic regresison classifier
for sim_idx_sub = sim_idxs_sub
    for rep_idx = rep_idxs
        PATH.rep_idx = rep_idx; 
        PATH.DATA_FOLDER = sprintf('sim%d.%d_%s', sim_idx, sim_idx_sub, simName);
        
        groupMVPA(PATH, FILENAME, propChoice, optionChoice, methodChoice, logParam,...
            sampleSize,nTimePoints,saveData,showPlot)
    end
end