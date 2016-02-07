%% apply spatial blurring to the data
% given the data matrix and proportion (number of sensors)
function [blurredData] = spatialBluring(data, proportion)

subset.numBlurGroups = round(size(data,2) * proportion);
subset.gpSize = round(size(data,2) / subset.numBlurGroups);
for n = 1 : subset.numBlurGroups-1
    % select a subset (columns) of data
    subset.ind = randsample(size(data,2), subset.gpSize);
    % compute logical indices for selected units
    tempLogic = false(size(data,2),1); tempLogic(subset.ind) = true;
    % select the units
    subset.data{n} = data(:,tempLogic);
    % delete selected units (columns) in data
    data = data(:,~tempLogic);
end
% collect the remaining columns in data
subset.data{size(subset.data,2) + 1 } = data;

% re-compute blurred data
for n = 1 : subset.numBlurGroups
    blurredData(:,n) = mean(subset.data{n},2);
end

end