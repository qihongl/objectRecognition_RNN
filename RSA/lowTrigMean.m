function meanValue = lowTrigMean( matrix )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
temp = tril(matrix);
meanValue = mean(temp(temp ~= 0));
end

