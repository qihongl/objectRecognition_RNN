%% prototye to pattern 
% it reads neural network prototype, and generate the patterns
% @parameters:  filename - the fileanme for a prototype file (.xlsx)
%               thres1 - what does '1' means in the prototype  
%               sumSup - number of superordinate level categories 
% @return:      pattern - neural network pattern matrix, computed by direct sum

% limitations:
%   It assumes every superordinate categories uses the SAME prototype, 
%   which is an oversimplification

function [pattern, numCategory] = patternGen(filename, thres1)

    % Constants 
    thres0 = 1 - thres1;

    % read the prototype file
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
        % compute the threshold mask 
        % random value smaller the entry here will be assign 1; 0 otherwise
        mask = prototype * (thres1 - thres0) + thres0;
    end
    
    % construct the patterns by compute the direct sum 
    % rand ~ uniform[0,1] in matlab
    randomMatrix = rand(size(prototype,1),size(prototype,2));
    % blur prototype pattern
    distortedProto = bsxfun(@gt, mask, randomMatrix);
    pattern.full = distortedProto;
    
    pattern.sup = [pattern.full(:,1: numUnits.sup) , zeros(numInstances, numUnits.bas + numUnits.sub)];    
    pattern.bas = [zeros(numInstances, numUnits.sup), pattern.full(:, numUnits.sup + 1 : numUnits.sup + numUnits.bas), zeros(numInstances, numUnits.sub)] ;
    pattern.sub = [zeros(numInstances, numUnits.sup + numUnits.bas), pattern.full(:, numUnits.sup + numUnits.bas + 1: end)];   
    pattern.bas_sup = [pattern.full(:, 1:numUnits.sup + numUnits.bas), zeros(numInstances, numUnits.sub)] ;
    
    % compute the direct sum of pattern matrix 
    % for full matrix, sup, bas and sub matrix, respectively 
    for i = 1: numCategory.sup - 1
        randomMatrix = rand(size(prototype,1), size(prototype,2));
        distortedProto = bsxfun(@gt, mask, randomMatrix);
        pattern.full = dsum(pattern.full, distortedProto);
        
        pattern.sup = dsum( pattern.sup, [distortedProto(:,1: numUnits.sup) , zeros(numInstances, numUnits.bas + numUnits.sub)] );
        pattern.bas = dsum( pattern.bas, [zeros(numInstances, numUnits.sup), distortedProto(:, numUnits.sup + 1 : numUnits.sup + numUnits.bas), zeros(numInstances, numUnits.sub)] );
        pattern.sub = dsum( pattern.sub, [zeros(numInstances, numUnits.sup + numUnits.bas), distortedProto(:, numUnits.sup + numUnits.bas + 1: end)]);   
        pattern.bas_sup = dsum( pattern.bas_sup, [distortedProto(:, 1:numUnits.sup + numUnits.bas), zeros(numInstances, numUnits.sub)] );
    end
  
end
