%% Generate the stimuli file for my PDP model for semantics
clear; clc; close all;
% CONSTANTS
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/patternGen';

%% Parameters
% get full patterns
protoName = 'PROTO3.xlsx';
% write to a file
filename = fopen('environment.txt','w');
filenameTest = fopen('allStimuli.txt','w');

% set a seed (for replicability )
parameters.seed = 2;
rng(parameters.seed);% TODO consider move it to patternGen

% the threshold is "P(being ON)" for all unit that "suppose" to be on
% (defined by the prototype)
parameters.visualThres = 1;
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
parameters.max = 5;
parameters.grace = 0.5;

allTargetTypes = {'visual_sup', 'visual_bas_sup', 'visual_all', ...
    'verbal_none', 'verbal_sup',  'verbal_bas', 'verbal_sub'};

%% get patterns
[protoParam, prototype] = readPrototype (protoName);
[visualPatterns] = patternGen(protoParam, prototype, parameters.visualThres);
[verbalPatterns] = patternGen(protoParam, prototype, parameters.verbalThres);
% generate names for all patterns
visualPatterns.names = nameGen(visualPatterns.numCategory);
verbalPatterns.names = nameGen(verbalPatterns.numCategory);

%% save the actual pattern used
saveParams(parameters, visualPatterns, verbalPatterns, protoParam, prototype)

%% write all patterns to a file
writeParameters(filename, parameters, visualPatterns);
writeParameters(filenameTest, parameters, visualPatterns);

% verbal -> visual
addTitle(filename, '# verbal sup -> visual sup features' )
targetType = 'visual_sup';
names = addPrefix('verbal', verbalPatterns.names, 'sup');
writeAllPatterns(filename, names, stimulusLength, ...
    verbalPatterns.sup, visualPatterns.sup, protoParam, targetType, 2)
clear names;

addTitle(filename, '# verbal bas -> visual bas + sup features' )
targetType = 'visual_bas+sup';
names = addPrefix('verbal', verbalPatterns.names, 'bas');
writeAllPatterns(filename, names, stimulusLength, verbalPatterns.bas, ...
    visualPatterns.sup_bas, protoParam, targetType, 2)
clear names;

addTitle(filename, '# verbal sub -> visual full features' )
targetType = 'visual_all';
names = addPrefix('verbal', verbalPatterns.names, 'sub');
writeAllPatterns(filename, names, stimulusLength, verbalPatterns.sub, ...
    visualPatterns.full, protoParam, targetType, 2)
clear names;


% write visual full -> verbal full (for tempDyn)
addTitle(filename, '# visual full -> verbal full' )
names = addPrefix('visual', visualPatterns.names, '');
targetType = 'verbal_none';
% writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
%     verbalPatterns.full, protoParam, targetType, 1)
% testing file
writeAllPatterns(filenameTest, names, stimulusLength, visualPatterns.full, ...
    verbalPatterns.full, protoParam, targetType, 1)
clear names;


% write visual full to 3 levels of names
addTitle(filename, '# visual full -> verbal sup' )
targetType = 'verbal_sup';
names = addPrefix('visual', visualPatterns.names, 'sup');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
    verbalPatterns.sup, protoParam, targetType, 1)
clear names;

addTitle(filename, '# visual full -> verbal bas' )
targetType = 'verbal_bas';
names = addPrefix('visual', visualPatterns.names, 'bas');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
    verbalPatterns.bas, protoParam, targetType, 1)
clear names;

addTitle(filename, '# visual full -> verbal sub' )
targetType = 'verbal_sub';
names = addPrefix('visual', visualPatterns.names, 'sub');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
    verbalPatterns.sub, protoParam, targetType, 1)
clear names;



%% manipulate frequency (add more basic training patterns)
freq = 9; 
for f = 1 : freq
    targetType = 'verbal_bas';
    addTitle(filename, '# visual full -> verbal bas' )
    names = addPrefix('visual', visualPatterns.names, 'bas');
    writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
        verbalPatterns.bas, protoParam, targetType, 1)
    clear names;
    
%     targetType = 'visual_bas+sup';
%     addTitle(filename, '# verbal bas -> visual bas + sup features' )
%     names = addPrefix('verbal', verbalPatterns.names, 'bas');
%     writeAllPatterns(filename, names, stimulusLength, verbalPatterns.bas, ...
%         visualPatterns.sup_bas, protoParam, targetType, 2)
%     clear names;
end


disp('Done!')