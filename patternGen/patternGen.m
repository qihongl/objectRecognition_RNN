%% prototye to pattern
% it reads neural network prototype, and generate the patterns
% @parameters:  filename - the fileanme for a prototype file (.xlsx)
%               thres1 - what does '1' means in the prototype
%               sumSup - number of superordinate level categories
% @return:      pattern - neural network pattern matrix, computed by direct sum

% limitations:
%   It assumes every superordinate categories uses the SAME prototype,
%   which is an oversimplification

function [pattern] = patternGen(filename, thres1)

% read the prototype file
[param, prototype] = readPrototype (filename); 
numUnits = param.numUnits;
numCategory = param.numCategory;
numInstances = param.numInstances;

% compute the threshold mask
% random value smaller the entry here will be assign 1; 0 otherwise
thres0 = 1 - thres1;
mask = prototype * (thres1 - thres0) + thres0;


%% check some input parameters
if numUnits.total ~= size(prototype,2)
    error('The Pattern Size is inconsistent with the parameter <numUnits>.')
end
if numCategory.bas * numCategory.sub ~=  numInstances
    error('The number of instances is inconsistent with the parameters that indicate number of categories.')
end

%% get blurred patterns
% get a random matrix, where entries are given by uniform[0,1]
randomMatrix = rand(size(prototype,1),size(prototype,2));
% blur prototype pattern
distortedProto = bsxfun(@gt, mask, randomMatrix);

%% get sub patterns
% construct patterns each category, separately
pattern = computeSubpatterns(distortedProto, numUnits);

%% expand it according to the number of superordinate categories
% compute the direct sum of pattern matrix
% for full matrix, sup, bas and sub matrix, respectively
for i = 1: numCategory.sup - 1
    % re-generate a random matrix everytime to ensure every
    % super-category has slightly different similiarity structure
    randomMatrix = rand(size(prototype,1), size(prototype,2));
    distortedProto = bsxfun(@gt, mask, randomMatrix);
    pattern.full = dsum(pattern.full, distortedProto);
    
    % compute subset patterns
    pattern.sup = dsum( pattern.sup, [distortedProto(:,1: numUnits.sup) , zeros(numInstances, numUnits.bas + numUnits.sub)] );
    pattern.bas = dsum( pattern.bas, [zeros(numInstances, numUnits.sup), distortedProto(:, numUnits.sup + 1 : numUnits.sup + numUnits.bas), zeros(numInstances, numUnits.sub)] );
    pattern.sub = dsum( pattern.sub, [zeros(numInstances, numUnits.sup + numUnits.bas), distortedProto(:, numUnits.sup + numUnits.bas + 1: end)]);
    pattern.sup_bas = dsum( pattern.sup_bas, [distortedProto(:, 1:numUnits.sup + numUnits.bas), zeros(numInstances, numUnits.sub)] );
end

% comptue other parameters
pattern.numCategory = numCategory;
pattern.numUnits = numUnits;
pattern.numTotalUnits = numUnits.total * numCategory.sup;
pattern.numTotalInstances = numInstances * numCategory.sup;
end

%% This function constructs "sub-patterns"
function pattern = computeSubpatterns(fullPattern, numUnits)
% full pattern
pattern.full = fullPattern;
% superordinate pattern
pattern.sup = fullPattern;
pattern.sup(:, (numUnits.sup + 1) : end) = 0;
% basic pattern
pattern.bas = fullPattern;
pattern.bas(:, 1: numUnits.sup) = 0;
pattern.bas(:, numUnits.sup + numUnits.bas + 1 : end) = 0;
% subordinate pattern
pattern.sub = fullPattern;
pattern.sub(:, 1: numUnits.sup + numUnits.bas) = 0;
% superordiante and basic pattern
pattern.sup_bas = fullPattern;
pattern.sup_bas(:,numUnits.sup + numUnits.bas + 1 :end) = 0;
end


