%% run a bunch of classifier
% when simulating using random subset or normal noise, there is randomness
% so we need a sample to establish average

sampleSize = 20;
timePoints = 25;
%% parameter for logistic regresison classifier
% classOpt = classification options
% 0 -> normal classifcation
% 1 -> classification with Spatial bluring
% 2 -> classifcation with random subset of neurons.
% propChoice = [.01 .05 .15 .3 1];
propChoice = .005;
logParam.classOpt = 'spatBlurring';
% variance of the normal noise
logParam.variance = 0;

for p = 1: length(propChoice);
    logParam.subsetProp = propChoice(p);
    
    %% run the analysis
    % preallocate
    group.accuracy = nan(timePoints,sampleSize);
    group.deviation = nan(timePoints,sampleSize);
    group.response = nan(timePoints,sampleSize);
    for i = 1 : sampleSize
        % run classifier and compute average
        [gs, param] = runClassifier(logParam,false);
        
        % record the average scores in 3 matrices
        group.accuracy(:,i) = gs.averageScore.accuracy;
        group.deviation(:,i) = gs.averageScore.deviation;
        group.response(:,i) = gs.averageScore.response;
        
    end
    
    %% save the results
    dataDirName = sprintf('groupScores/');
    if exist(dataDirName,'dir') ~= 7
        mkdir(dataDirName)
    else
        warning('Directory exists!')
    end
    dataFileName = sprintf('gsClass_%s%.3d.mat', logParam.classOpt, logParam.subsetProp * 100);
    save([dataDirName '/' dataFileName],'group')
end
