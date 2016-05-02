function [data] = summarizeTempRsaData(condition,dataPath)
%% load file and compute summarized data
listing = dir( strcat(dataPath, '/gRSA_' ,condition, '*.mat'));

numFiles = size(listing,1);
for i = 1:numFiles
    % load a data file
    fileName = listing(i).name;
    load([dataPath '/' fileName])
    % compute mean
    data.mean.basic(:,i) = mean(corr.basic,2);
    data.mean.super(:,i) = mean(corr.super,2);
    % compute std (to build CI)
    data.sd.basic(:,i) = std(corr.basic);
    data.sd.super(:,i) = std(corr.super);
    
end
end