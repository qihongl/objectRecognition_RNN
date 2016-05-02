%% run a bunch of classifier
% when simulating using random subset or normal noise, there is randomness
% so we need a sample to establish average
clear variables; clc;
sampleSize = 10;
timePoints = 25;
saveData = 1;
showPlot = 0; 

%% Specify the Path information (user needs to do this!)
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% PATH.DATA_FOLDER = 'sim22.1_RSVP';
PATH.DATA_FOLDER = 'sim25.2_RSVP';
% PATH.DATA_FOLDER = 'sim25.2_noVisNoise';
% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'hiddenAll_e2.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';
todayDate = date;

%% parameter for logistic regresison classifier
% classOpt = classification options
propChoice = [.005 .01 .05 .15 .3];
optionChoice = {'randomSubset', 'spatBlurring'};
% propChoice = [.05];
% optionChoice = {'randomSubset'};
logParam.var = 0; 

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
        group.hitRate = nan(timePoints,sampleSize);
        group.falseRate = nan(timePoints,sampleSize);
        for i = 1 : sampleSize
            % run classifier and compute average
            [gs, param] = runClassifier(logParam,PATH,FILENAME,showPlot);
            
            % record the average scores in 5 matrices
            group.accuracy(:,i) = gs.averageScore.accuracy;
            group.deviation(:,i) = gs.averageScore.deviation;
            group.response(:,i) = gs.averageScore.response;
            group.hitRate(:,i) = gs.averageScore.hitRate;
            group.falseRate(:,i) = gs.averageScore.falseRate; 
            fprintf('%2.d ',i);
        end
        
        %% read metadata
        if saveData
            dataDirName = sprintf('groupScores_class/');
            subDataDirName = getSubDataDirName(PATH,FILENAME);
            finalSavePath = strcat(dataDirName,subDataDirName,'_',todayDate);
            %% save the results
            checkAndMkdir(dataDirName);
            checkAndMkdir(finalSavePath);
            % 
            dataFileName = sprintf('gsClass_%s%.3d.mat', ...
                logParam.classOpt, logParam.subsetProp * 1000);
            
            save([finalSavePath '/' dataFileName],'group')
        end
    end
end

%
datetime
