%% compute a sample of RDM correlation scores (for statistics)
clear all; clc; clf;
%% parameters
param.option = 'randomSubset';
param.propChoices = [.01, .05, .15, .3, 1];
sampleSize = 20;

for p = 1 : length(param.propChoices)
    % loop over all choices of proportion parameter
    param.porp = param.propChoices(p)
    
    %% path info
    PATH.ABS = '/Users/Qihong/Dropbox/github/categorization_PDP/';
    % provide the NAMEs of the data files (user need to set them mannually)
    PATH.DATA= 'sim23.3_noise';
    FILENAME.VERBAL = 'hiddenAll_e2.txt';
    FILENAME.PROTOTYPE = 'PROTO.xlsx';
    
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
    
    %% save the results
    dataDirName = sprintf('groupScores_RSA/');
    if exist(dataDirName,'dir') ~= 7
        mkdir(dataDirName)
    else
        warning('Directory exists!')
    end
    % save time x subject correlational data file
    corrDataFileName = sprintf('gRSA_%s%.3d', param.option, param.porp * 100);
    save([dataDirName '/' corrDataFileName],'corr')
    % save RDMs
    rdmDataFileName = sprintf('gRDM_%s%.3d', param.option, param.porp * 100);
    save([dataDirName '/' rdmDataFileName],'RDMs')
end