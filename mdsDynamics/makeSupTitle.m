function [] = makeSupTitle( method,subsetSize, simSize )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if strcmp(method,'normal')
    suptitle_text = sprintf('Method: %s, GroupSize: NA, SimSampleSize: %d', ...
        method, simSize);
else
    suptitle_text = sprintf('Method: %s, GroupSize: %d, SimSampleSize: %d', ...
        method,subsetSize, simSize);
end
suptitle(suptitle_text)
end

