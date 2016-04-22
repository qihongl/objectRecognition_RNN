function [ meanSpreadSup ] = getSpread_byPDist( data, param, idx, nTimePts )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

% constants
METRIC = 'euclidean';
nObjs_sup = param.numCategory.bas*param.numCategory.sub;

% preallocate 
meanSpreadSup.within = nan(nTimePts,1);
meanSpreadSup.between = nan(nTimePts,1);
for t = 1 : nTimePts;
    %% split the data matrix, by super category
    dataSup_t = cell(param.numCategory.sup,1);
    for j = 1: param.numCategory.sup
        supCategoryIndices = 1 + ((j-1) * nObjs_sup) : nObjs_sup * j;
        dataSup_t{j} = data(idx(supCategoryIndices,t),:);
    end
    
    %% compute the between vs. within spread for all super categories
    for j = 1: param.numCategory.sup
        % the within spread for jth super category
        % mean of all possible pair wise disatnces
        spreadSup.within(j) = mean(pdist(dataSup_t{j}, METRIC));
        
        % get the rest of the data, w.r.t to the current sup category
        restIdx = true(param.numCategory.sup,1);
        restIdx(j) = false;
        restOfData = cell2mat(dataSup_t(restIdx));
        % get the between category spread
        spreadSup.bet(j) = mean(mean(pdist2(dataSup_t{j}, restOfData, METRIC)));
        
    end
    
    % save the average; 
    meanSpreadSup.within(t) = mean(spreadSup.within);
    meanSpreadSup.between(t) = mean(spreadSup.bet);
    
end

end

