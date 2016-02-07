%% select a random subset of the columns
% given proportion and the data matrix
function [subsetData] = selectRandomSubset(data, proportion)
% number of units to be selected
subset.numUnits = round(proportion * size(data,2));
% selection indices
subset.ind = randsample(size(data,2),subset.numUnits);
% subset the data
subsetData = data(:,subset.ind);
end