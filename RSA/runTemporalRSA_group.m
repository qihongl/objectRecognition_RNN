%% compute a sample of RDM correlation scores (for statistics)
clear all; clc; clf;

%% path info
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% PATH.DATA_FOLDER = 'sim16_large';
PATH.DATA_FOLDER = 'sim23.3_noise';
% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'hiddenAll_e7.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%% parameters
sampleSize = 20;
param.optionChoices = {'randomSubset','spatBlurring'};
param.propChoices = [.01, .05, .15, .3 1];

%% start data recording
% loop over all choices of conditions
for opt = 1 : length(param.optionChoices)
    param.option = param.optionChoices{opt};
    
    % loop over all choices of proportion parameter
    for p = 1 : length(param.propChoices)
        param.porp = param.propChoices(p)
        
        %% Run group analysis
        % preallocate fields
        timePoints = 25;
        corr.basic = nan(timePoints, sampleSize);
        corr.super = nan(timePoints, sampleSize);
        % run a sample of temporal RDM simulations
        RDMs = cell(sampleSize,1);
        for i = 1 : sampleSize
            % RDMs: each cell has a time series for a diff. "subject"
            [corrData RDMs{i}] = runTemporalRSA(param, PATH, FILENAME);
            
            % corr: time by subject correlation matrix
            corr.basic(:,i) = corrData.basic';
            corr.super(:,i) = corrData.super';
        end
        
        %% get save dir names
        dataDirName = sprintf('groupScores_RSA/');
        subDataDirName = getSubDataDirName(PATH,FILENAME);
        finalSavePath = strcat(dataDirName,subDataDirName);
        % create data dir
        checkAndMkdir(dataDirName);
        checkAndMkdir(finalSavePath);
        %% save the results
        % save time x subject correlational data file
        corrDataFileName = sprintf('gRSA_%s%.3d', param.option, param.porp * 100);
        save([finalSavePath '/' corrDataFileName],'corr')
        % save RDMs
        rdmDataFileName = sprintf('gRDM_%s%.3d', param.option, param.porp * 100);
        save([finalSavePath '/' rdmDataFileName],'RDMs')
    end
end