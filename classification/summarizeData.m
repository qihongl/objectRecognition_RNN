function [data, propUsed] = summarizeData(listing, pathName, condition)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

numFiles = size(listing,1);
propUsed = cell(numFiles,1);
for i = 1:numFiles
    % load a data file
    fileName = listing(i).name;
    load([pathName '/' fileName])
    % build legend
    propUsed{i} = extractPropUsed(fileName, condition)/10;
    
    % compute means
    data.mean.acc(:,i) = mean(group.accuracy,2);
    data.mean.dev(:,i) = mean(group.deviation,2);
    data.mean.hr(:,i) = mean(group.hitRate,2);
    data.mean.fr(:,i) = mean(group.falseRate,2);
    % compute std (to build CI)
    data.sd.acc(:,i) = std(group.accuracy,0,2);
    data.sd.dev(:,i) = std(group.deviation,0,2);
    data.sd.hr(:,i) = std(group.hitRate,0,2);
    data.sd.fr(:,i) = std(group.falseRate,0,2);
end
end

