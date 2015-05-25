function [numUnits, numCategory, numInstances, prototype] = readPrototype (filename)
%READPROTOTYPE Summary of this function goes here
%   Detailed explanation goes here
if exist(filename, 'file') == 0
    error([ 'File ' filename ' not found. Please make sure the '...
        'prototype file is in the working directory.'])
else
    
    temp = xlsread(filename);
    % the 1st line contains the metadata in the following order
    numUnits.sup = temp(1,1);
    numUnits.bas = temp(1,2);
    numUnits.sub = temp(1,3);
    numCategory.sup = temp(1,4);
    numCategory.bas = temp(1,5);
    numCategory.sub = temp(1,6);
    % the rest is the prototype
    numInstances = size(temp,1) - 2; % -1, as 1st row is metadata, 2nd row has indices
    % skip the 1st, 2nd line (2nd line has indices)
    prototype = temp(3:end,:);
end

end