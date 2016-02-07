%% compute a sample of RDM correlation scores (for statistics)

%% parameters
param.option = 'spatBlurring';
param.porp = 0.15; 
sampleSize = 10;

%% Run group analysis
% preallocate fields
timePoints = 25;
corr.basic = nan(timePoints, sampleSize);
corr.super = nan(timePoints, sampleSize);
% run a sample of temporal RDM simulations
for i = 1 : sampleSize
    corrData = runTemporalRSA(param);
    corr.basic(:,i) = corrData.basic';
    corr.super(:,i) = corrData.super';
end

%% save the results
dataDirName = sprintf('groupScores_RSA/');
if exist(dataDirName,'dir') ~= 7
    mkdir(dataDirName)
else
    warning('Directory exists!')
end
dataFileName = sprintf('gRSA_blur_%s%.3d', param.option, param.porp * 100);
save([dataDirName '/' dataFileName],'corr')
