%% plot the temporal RSA
% this program relies on the output file of 'testAllActs'
% it is designed to process the output for the verbal representation layer
function [temporalCorr, temporalRDMs] = runTemporalRSA(param, PATH, FILENAME)
%% CONSTANTS
% clear; clc; clf; close all;
EPOCH = 2000;

%% options
showPlot = 0;
% option = 'randomSubset';
% option = 'spatBlurring';
option = param.option; 
proportion = param.porp;

%% read data
% read the output data
PATH.FULL = [PATH.PROJECT PATH.DATA_FOLDER];
% check if the data file exists
if exist([PATH.FULL '/' FILENAME.DATA], 'file') == 0
    error([ 'File ' FILENAME.DATA ' not found.'])
end
outputFile = tdfread([PATH.FULL '/' FILENAME.DATA]);
name = char(fieldnames(outputFile));
output = getfield(outputFile, name);

% output = output(547:end,:); % if run on old data set

% read the prototype pattern, to get some parameters of the simulation
[param, prototype] = readPrototype ([PATH.FULL '/' FILENAME.PROTOTYPE]);
% param.numStimuli = param.numInstances * param.numCategory.sup;
prototype = logical(prototype);

%% preprocessing
% add a zero row at the beginning so that every pattern has equal numRows
output = vertcat( zeros(1,size(output,2)), output);
INTERVAL = size(output,1) / param.numStimuli;
% split the data
data = mat2cell(output, repmat(INTERVAL, [1 param.numStimuli]), size(output,2) );
for i = 1 : size(data,1)
    data{i} = data{i}(:, 3:end);    % remove the 1st & 2nd columns
    data{i} = data{i}(2:end,:);     % remove the 1st row of zeros
end

%% compute RDMs
% for each time point, get a stimuli by voxel matrix
% then compute the RDM
timeSliceData = cell(INTERVAL-1,1);
processedData = cell(INTERVAL-1,1);
temporalRDMs = cell(INTERVAL-1,1);

for j = 1 : INTERVAL-1;
    temp = nan(size(data,1), param.numUnits.total * param.numCategory.sup);
    for i = 1:size(data,1)
        temp(i,:) = data{i}(j,:);
    end
    timeSliceData{j} = temp;
    
    % blur or the data
    if strcmp(option,'randomSubset')
        processedData{j} = selectRandomSubset(timeSliceData{j}, proportion);
    elseif strcmp(option,'spatBlurring')
        processedData{j} = spatialBluring(timeSliceData{j}, proportion);
    else
        disp('no blurring or subset selection was performed')
        processedData{j} = timeSliceData{j};
    end
    
    % compute the RDM
    temporalRDMs{j} = computeRDM(processedData{j});
end

% now you can compute RDM like so
% colormap jet
% imagesc(temporalRDMs{25})

%% compare to the theoritical basic level matrix
basicPatterns = dsum(prototype,prototype);
basicPatterns = dsum(basicPatterns,prototype);
basicRDM = computeRDM(basicPatterns);
superPatterns = dsum(ones(param.numInstances,param.numInstances),ones(param.numInstances,param.numInstances));
superPatterns = dsum(superPatterns,ones(param.numInstances,param.numInstances));
superRDM = computeRDM(superPatterns);

%% compute RDM correlation for all time points
for i = 1 : INTERVAL-1
    temporalCorr.basic(i) = corr(basicRDM(:), temporalRDMs{i}(:));
    temporalCorr.super(i) = corr(superRDM(:), temporalRDMs{i}(:));
end
% eliminate nan values
temporalCorr.basic(isnan(temporalCorr.basic)) = 0;
temporalCorr.super(isnan(temporalCorr.super)) = 0;


%% visualization
if showPlot
    plotTemporalCorr_RDM(temporalCorr)
end

end
