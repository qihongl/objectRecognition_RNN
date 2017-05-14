function [ newData ] = eegSimulation( rawData, method, subsetSize, param )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% select random subset or blurring 
% randPermOrder = randperm(param.numUnits.total * param.numCategory.sup);
randPermOrder = randperm(78); % TODO temp solution! wrong!
if strcmp(method, 'randomSubset')
%     sprintf('Method: randomSubset.\n')
    subsetIdx = randPermOrder(1:subsetSize);
    newData = rawData(:,subsetIdx);
elseif strcmp(method, 'spatialBlurring')
%     sprintf('Method: spatialBlurring.\n')
    % split the rawData into N subgroup
    if subsetSize > 1
        subset.gpSize = round(size(rawData,2) / subsetSize);
        for n = 1 : subsetSize-1
            % select a subset (columns) of rawData
            subset.ind = randsample(size(rawData,2), subset.gpSize);
            % compute logical indices for selected units
            tempLogic = false(size(rawData,2),1); tempLogic(subset.ind) = true;
            % select the units
            subset.rawData{n} = rawData(:,tempLogic);
            % delete selected units (columns) in rawData
            rawData = rawData(:,~tempLogic);
        end
        % collect the remaining columns in rawData
        subset.rawData{size(subset.rawData,2) + 1 } = rawData;
        % re-compute blurred rawData
        clear rawData;
        for n = 1 : subsetSize
            newData(:,n) = mean(subset.rawData{n},2);
        end
    else % if there is only one group 
        newData = mean(rawData,2);
    end

else
%     sprintf('Method: NA.\n')
    newData = rawData;
end


end

