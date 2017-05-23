%% Generate the stimuli file for my PDP model for semantics
clear variables; clc; close all;
% set a seed (for replicability )
envParam.seed = 2; rng(envParam.seed); % TODO consider move it to patternGen
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/patternGen';


%% Parameters
% get full patterns
protoName = 'PROTO.csv';
trainFileName = 'train.txt';
testFileName = 'test.txt';

allThings = {'otherSupCategories', 'otherLevels'};
envParam.thingsToBeMasked = allThings{2};
rapidPresentation = false; 

% the threshold is "P(being ON)" for all unit that "suppose" to be on
% (defined by the prototype)
envParam.visualThres = 1;
% verbal threshold is always on. For basic and superordiante category, name
% should be the same for all members of the category
envParam.verbalThres = 1;

% modeling envParam
stimulusLength = 15;
envParam.defI = 0;
envParam.defT = NaN;
envParam.actI = 1;
envParam.actT = 1;
envParam.min = 0.5;
parameters_test.min = 0.5;
envParam.max = 5;
envParam.grace = 0;

allTargetTypes = {'visual_sup', 'visual_bas_sup', 'visual_all', ...
    'verbal_none', 'verbal_sup',  'verbal_bas', 'verbal_sub'};



%% get patterns
[param, prototype] = readPrototype(protoName);
param.thingsToBeMasked = envParam.thingsToBeMasked;
[visualPatterns] = patternGen(param, prototype, envParam.visualThres);
[verbalPatterns] = patternGen(param, prototype, envParam.verbalThres);
% generate names for all patterns
visualPatterns.names = nameGen(visualPatterns.numCategory);
verbalPatterns.names = nameGen(verbalPatterns.numCategory);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start generating patterns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = fopen(trainFileName,'w');
filenameTest = fopen(testFileName,'w');
% save the actual pattern used
saveParams(envParam, visualPatterns, verbalPatterns, param, prototype)

%% training set 
param.rapidPresentation = false; 
writeParameters(filename, envParam, visualPatterns);
% verbal -> visual
addTitle(filename, '# verbal sup -> visual sup features' )
targetType = 'visual_sup';
names = addPrefix('verbal', verbalPatterns.names, 'sup');
writeAllPatterns(filename, names, stimulusLength, ...
    verbalPatterns.sup, visualPatterns.sup, param, targetType, 2)

addTitle(filename, '# verbal bas -> visual bas + sup features' )
targetType = 'visual_bas+sup';
names = addPrefix('verbal', verbalPatterns.names, 'bas');
writeAllPatterns(filename, names, stimulusLength, verbalPatterns.bas, ...
    visualPatterns.sup_bas, param, targetType, 2)

addTitle(filename, '# verbal sub -> visual full features' )
targetType = 'visual_all';
names = addPrefix('verbal', verbalPatterns.names, 'sub');
writeAllPatterns(filename, names, stimulusLength, verbalPatterns.sub, ...
    visualPatterns.full, param, targetType, 2)


% write visual full to 3 levels of names
addTitle(filename, '# visual full -> verbal sup' )
targetType = 'verbal_sup';
names = addPrefix('visual', visualPatterns.names, 'sup');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
    verbalPatterns.sup, param, targetType, 1)

addTitle(filename, '# visual full -> verbal bas' )
targetType = 'verbal_bas';
names = addPrefix('visual', visualPatterns.names, 'bas');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
    verbalPatterns.bas, param, targetType, 1)

addTitle(filename, '# visual full -> verbal sub' )
targetType = 'verbal_sub';
names = addPrefix('visual', visualPatterns.names, 'sub');
writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
    verbalPatterns.sub, param, targetType, 1)


%% manipulate frequency (add more basic training patterns)
freq = 9; 
for f = 1 : freq
    targetType = 'verbal_bas';
    addTitle(filename, '# visual full -> verbal bas' )
    names = addPrefix('visual', visualPatterns.names, 'bas');
    writeAllPatterns(filename, names, stimulusLength, visualPatterns.full, ...
        verbalPatterns.bas, param, targetType, 1) 
    
    targetType = 'visual_bas+sup';
    addTitle(filename, '# verbal bas -> visual bas + sup features' )
    names = addPrefix('verbal', verbalPatterns.names, 'bas');
    writeAllPatterns(filename, names, stimulusLength, verbalPatterns.bas, ...
        visualPatterns.sup_bas, param, targetType, 2)
end



%% test set
param.rapidPresentation = rapidPresentation; 
envParam.min = parameters_test.min;
writeParameters(filenameTest, envParam, visualPatterns);
% write visual full -> verbal full (for tempDyn)
addTitle(filename, '# visual full -> verbal full' )
targetType = 'verbal_none';
names = addPrefix('visual', visualPatterns.names, '');
writeAllPatterns(filenameTest, names, stimulusLength, visualPatterns.full, ...
    verbalPatterns.full, param, targetType, 1)


disp('Done!')