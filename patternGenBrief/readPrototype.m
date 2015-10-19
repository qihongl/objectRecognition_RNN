function [param, prototype] = readPrototype (filename)
%READPROTOTYPE 
%   this function takes a prototype pattern and returns the following: 
% 
%   numUnits.sup - number of units that represents super-features
%   numUnits.bas - number of units that represents basic-features
%   numUnits.sub - number of units that represents sub-features
%   numUnits.total - number of total units that represents this super class of objects
%   numCategory.sup - number of super categories
%   numCategory.bas - number of basic categories in each super category 
%   numCategory.sub - number of sub categories in each basic category
%   numInstances - number of objects in each super category
%   numStimuli - total number of stimuli that the model is going to learn
%   prototype - the prototype patterns

    if exist(filename, 'file') == 0
        error([ 'File ' filename ' not found. Please make sure the '...
            'prototype file is in the working directory.'])
    else
        % load the prototype file
        temp = xlsread(filename);
        
        % the 1st line contains the modeling parameters in the following order
        param.numUnits.sup = temp(1,1);     
        param.numUnits.bas = temp(1,2);     
        param.numUnits.sub = temp(1,3);     
        param.numUnits.total = sum(struct2array(param.numUnits)); 
        param.numCategory.sup = temp(1,4);
        param.numCategory.bas = temp(1,5);
        param.numCategory.sub = temp(1,6);

        % the rest is the prototype
        % skip the 1st, 2nd line (2nd line has indices)
        prototype = temp(3:end,:);

        % -2, as 1st row is metadata, 2nd row has indices
        param.numInstances = size(temp,1) - 2; 
        % get the number of total stimuli that the model is going to see
        param.numStimuli = param.numInstances * param.numCategory.sup;

    end

end