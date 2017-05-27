%% summarize results for the group MVPA analysis 
function [results, propUsed] = summarizeData_gm(listing, pathName, condition)
% get params 
numFiles = size(listing,1);
propUsed = cell(numFiles,1);
filenames = lists2names(listing); 
for i = 1:numFiles
    % load a results file
    load([pathName '/' filenames{i}])
    % build legend
    propUsed{i} = extractPropUsed(filenames{i}, condition)/10;
    
    % compute means
    results.mean.acc(:,i) = mean(group.accuracy,2);
    results.mean.dev(:,i) = mean(group.deviation,2);
    results.mean.hr(:,i) = mean(group.hitRate,2);
    results.mean.fr(:,i) = mean(group.falseRate,2);
    % compute std (to build CI)
    results.sd.acc(:,i) = std(group.accuracy,0,2);
    results.sd.dev(:,i) = std(group.deviation,0,2);
    results.sd.hr(:,i) = std(group.hitRate,0,2);
    results.sd.fr(:,i) = std(group.falseRate,0,2);
end
end

