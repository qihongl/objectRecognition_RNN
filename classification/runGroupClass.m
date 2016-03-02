%% run a bunch of classifier
% when simulating using random subset or normal noise, there is randomness
% so we need a sample to establish average
clear variables; clc; 
sampleSize = 20;
timePoints = 25;

%% Specify the Path information (user needs to do this!)
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% PATH.DATA_FOLDER = 'sim16_large';
PATH.DATA_FOLDER = 'sim22.0_RSVP';
% PATH.DATA_FOLDER = 'sim23.2_noise';
% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'hiddenAll_e3.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%% parameter for logistic regresison classifier
% classOpt = classification options
propChoice = [.005 .01 .05 .15 .3 1];
% propChoice = [.01 .05 .15 .3 1];
optionChoice = {'randomSubset', 'spatBlurring'};

% variance of the normal noise
logParam.variance = 0;

% loop over all option choices
for opt = 1 : length(optionChoice)    
    logParam.classOpt = optionChoice{opt};
    % loop over all proportion parameters
    
    for p = 1: length(propChoice);
        logParam.subsetProp = propChoice(p);
        
        %% run the analysis
        % preallocate
        group.accuracy = nan(timePoints,sampleSize);
        group.deviation = nan(timePoints,sampleSize);
        group.response = nan(timePoints,sampleSize);
        for i = 1 : sampleSize
            % run classifier and compute average
            [gs, param] = runClassifier(logParam,PATH,FILENAME,0);
            % record the average scores in 3 matrices
            group.accuracy(:,i) = gs.averageScore.accuracy;
            group.deviation(:,i) = gs.averageScore.deviation;
            group.response(:,i) = gs.averageScore.response;
        end
        
        %% read metadata
        dataDirName = sprintf('groupScores_class/');
        subDataDirName = getSubDataDirName(PATH,FILENAME);
        finalSavePath = strcat(dataDirName,subDataDirName);
        %% save the results
        checkAndMkdir(dataDirName);
        checkAndMkdir(finalSavePath);
        
        dataFileName = sprintf('gsClass_%s%.3d.mat', logParam.classOpt, logParam.subsetProp * 100);
        save([finalSavePath '/' dataFileName],'group')
    end
end
