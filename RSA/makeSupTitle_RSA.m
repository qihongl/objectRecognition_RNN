function [] = makeSupTitle_RSA( condition, param, sampleSize )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% param - graph param

suptitle_text = sprintf( strcat('Correlation with theoretical matrix', ...
    ' | Method: %s | simSize: %d') , condition, sampleSize);

suptitle(suptitle_text);
end

