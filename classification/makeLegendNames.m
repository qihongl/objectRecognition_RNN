function [legendNames] = makeLegendNames( propUsed, condition )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numHiddenUnits = 156;
if strcmp(condition,'randomSubset')
    legendNames = propUsed;
    for i = 1 : length(legendNames)
        legendNames{i} = sprintf('%.2d %%', propUsed{i});
    end
    
    legendNames{1} = '1%'; %% To be fixed
    
elseif strcmp(condition,'spatBlurring')
    legendNames = cell(size(propUsed));
    for i = 1 : length(legendNames)
        legendNames{i} = sprintf('%d', ceil(numHiddenUnits * propUsed{i} * .01));
    end
    
    legendNames{1} = '1'; %% To be fixed
else 
    sprintf('Unrecognizable condition for generating legends')
end

end

