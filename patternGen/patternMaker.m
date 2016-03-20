%% Generate the stimuli file for my PDP model for semantics
clear; clc;
% CONSTANTS
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/patternGen';

%% Parameters
% get full patterns 
protoName = 'PROTO1.xlsx';
% write to a file
filename = fopen('environment.txt','w');
filenameTest = fopen('allStimuli.txt','w');

% set a seed (for replicability )
parameters.seed = 2;
rng(parameters.seed);% TODO consider move it to patternGen

% the threshold is "P(being ON)" for all unit that "suppose" to be on
% (defined by the prototype)
parameters.visualThres = 0.7;   
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
[visualPatterns] = patternGen(protoName, parameters.visualThres);
[verbalPatterns] = patternGen(protoName, parameters.verbalThres);
% generate names for all patterns
visualPatterns.names = nameGen(visualPatterns.numCategory);
verbalPatterns.names = nameGen(verbalPatterns.numCategory);


%% write all patterns to a file
writeParameters(filename, parameters, visualPatterns);
writeParameters(filenameTest, parameters, visualPatterns);

% verbal -> visual
addTitle(filename, '# verbal sup -> visual sup features' )
names = addPrefix('verbal', verbalPatterns.names, 'sup');
writeAllPatterns(filename, names, stimulusLength, verbalPatterns.sup, visualPatterns.sup, 2)
clear names;

addTitle(filename, '# verbal bas -> visual bas + sup features' )
names = addPrefix('verbal', verbalPatterns.names, 'bas');
writeAllPatterns(filename, names, stimulusLength, verbalPatterns.bas, visualPatterns.sup_bas, 2)
clear names;

addTitle(filename, '# verbal sub -> visual full features' )
names = addPrefix('verbal', verbalPatterns.names, 'sub');
writeAllPatterns(filename, names, stimulusLength, verbalPatterns.sub, visualPatterns.full, 2)
clear names;

% testing file
% write visual full -> verbal full (for tempDyn)
addTitle(filename, '# visual full -> verbal full' )
names = addPrefix('visual', visualPatterns.names, '');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.full, 1)
writeAllPatterns(filenameTest, names, stimulusLength, visualPatterns.full, verbalPatterns.full, 1)
clear names;


% write visual full to 3 levels of names
addTitle(filename, '# visual full -> verbal sup' )
names = addPrefix('visual', visualPatterns.names, 'sup');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.sup, 1)
clear names;

addTitle(filename, '# visual full -> verbal bas' )
names = addPrefix('visual', visualPatterns.names, 'bas');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.bas, 1)
clear names;

addTitle(filename, '# visual full -> verbal sub' )
names = addPrefix('visual', visualPatterns.names, 'sub');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.sub, 1)
clear names;



%% manipulate frequency (add more basic training patterns)

addTitle(filename, '# visual full -> verbal bas' )
names = addPrefix('visual', visualPatterns.names, 'bas');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, verbalPatterns.bas, 1)
clear names;

addTitle(filename, '# verbal bas -> visual bas + sup features' )
names = addPrefix('verbal', verbalPatterns.names, 'bas');
writeAllPatterns(filename, names, stimulusLength, verbalPatterns.bas, visualPatterns.sup_bas, 2)
clear names;


disp('Done!')