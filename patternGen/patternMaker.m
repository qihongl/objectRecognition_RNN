%% Generate the stimuli file for my PDP model for semantics
clear; clc;

%% Parameters
% get full patterns 
protoName = 'PROTO3.xlsx';
% write to a file
filename = fopen('environment.txt','w');
filenameTest = fopen('allStimuli.txt','w');

% some parameters
parameters.seed = 2;
rng(parameters.seed); % for replicability % TODO consider move it to patternGen

% the threshold is "P(being ON)" for all unit that "suppose" to be on
% (defined by the prototype)
parameters.visualThres = 0.9;   
% verbal threshold is always on. For basic and superordiante category, name
% should be the same for all members of the category
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



%% get patterns
[visualPatterns, numCategoryVis] = patternGen(protoName, parameters.visualThres);
[verbalPatterns, numCategoryVer] = patternGen(protoName, parameters.verbalThres);
% create names 
visualNames = nameGen(numCategoryVis);
verbalNames = nameGen(numCategoryVer);


% %% write to file
% writeParameters(filename, parameters, numCategoryVis);
% writeParameters(filenameTest, parameters, numCategoryVis);
% 
% % verbal -> visual
% addTitle(filename, '# verbal sup -> visual sup features' )
% names = addPrefix('verbal', verbalNames, 'sup');
% writeAllPatterns(filename, names, stimulusLength, verbalPatterns.sup, visualPatterns.sup, 2)
% clear names;
% 
% addTitle(filename, '# verbal bas -> visual bas + sup features' )
% names = addPrefix('verbal', verbalNames, 'bas');
% writeAllPatterns(filename, names, stimulusLength, verbalPatterns.bas, visualPatterns.bas_sup, 2)
% clear names;
% 
% addTitle(filename, '# verbal sub -> visual full features' )
% names = addPrefix('verbal', verbalNames, 'sub');
% writeAllPatterns(filename, names, stimulusLength, verbalPatterns.sub, visualPatterns.full, 2)
% clear names;
% 
% 
% % write visual full -> verbal full (for tempDyn)
% addTitle(filename, '# visual full -> verbal full' )
% names = addPrefix('visual', visualNames, '');
% writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.full, 1)
% writeAllPatterns(filenameTest, names, stimulusLength, visualPatterns.full, verbalPatterns.full, 1)
% clear names;
% 
% 
% % write visual full to 3 levels of names
% addTitle(filename, '# visual full -> verbal sup' )
% names = addPrefix('visual', visualNames, 'sup');
% writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.sup, 1)
% clear names;
% 
% addTitle(filename, '# visual full -> verbal bas' )
% names = addPrefix('visual', visualNames, 'bas');
% writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.bas, 1)
% clear names;
% 
% addTitle(filename, '# visual full -> verbal sub' )
% names = addPrefix('visual', visualNames, 'sub');
% writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.sub, 1)
% clear names;
% 
% 
% 
% 
% 
% 
% %% manipulate frequency
% 
% addTitle(filename, '# visual full -> verbal bas' )
% names = addPrefix('visual', visualNames, 'bas');
% writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.bas, 1)
% clear names;
% 
% addTitle(filename, '# verbal bas -> visual bas + sup features' )
% names = addPrefix('verbal', verbalNames, 'bas');
% writeAllPatterns(filename, names, stimulusLength, verbalPatterns.bas, visualPatterns.bas_sup, 2)
% clear names;