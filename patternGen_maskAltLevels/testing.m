% testing
clear; clc;

%% Parameters
% get full patterns 
protoName = 'PROTO1.xlsx';
% write to a file
filename = fopen('testing.txt','w');

% some parameters
parameters.seed = 1;
rng(parameters.seed); % replicability... 
parameters.visualThres = 1;
parameters.verbalThres = 1;


% modeling parameters
stimulusLength = 15;
parameters.defI = 0;
parameters.defT = NaN;
parameters.actI = 1;
parameters.actT = 1;
parameters.min = 0.5;
parameters.max = 3;
parameters.grace = 0.5;

writeParameters(filename, parameters);

%% get patterns
[visualPatterns, numCategoryVis] = patternGen(protoName, parameters.visualThres);
[verbalPatterns, numCategoryVer] = patternGen(protoName, parameters.verbalThres);
% create names 
visualNames = nameGen(numCategoryVis);
verbalNames = nameGen(numCategoryVer);

addTitle(filename, '# visual full -> verbal full' )
names = addPrefix('visual', visualNames, '');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.bas_sup, 1)
% writeAllPatterns(filenameTest, names, stimulusLength, visualPatterns.full, verbalPatterns.full, 1)
clear names;