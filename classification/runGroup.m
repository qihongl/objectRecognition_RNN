%% run a bunch of classifier
% when simulating using random subset or normal noise, there is randomness
% so we need a sample to establish average

sampleSize = 10;
timePoints = 25;

% preallocate 
group.accuracy = nan(timePoints,sampleSize);
group.deviation = nan(timePoints,sampleSize);
group.response = nan(timePoints,sampleSize);
for i = 1 : sampleSize
    % run classifier and compute average
    [gs, param, logParams] = runClassifier(0);
    
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
dataFileName = sprintf('gs_blur_subsetProp%.3d', logParams.subsetProp * 100);
save([dataDirName '/' dataFileName],'group')
