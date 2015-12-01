%% plot the temporal RSA
% this program relies on the output file of 'testAllActs'
% it is designed to process the output for the verbal representation layer

%% CONSTANTS
clear all; clc; clf; close all;
PATH.ABS = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
PATH.DATA= 'sim23.1_noise';
FILENAME.VERBAL = 'hiddenAll_e2.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';
EPOCH = 2000;

%% read data
% read the output data
PATH.FULL = [PATH.ABS PATH.DATA];
% check if the data file exists
if exist([PATH.FULL '/' FILENAME.VERBAL], 'file') == 0
    error([ 'File ' FILENAME.VERBAL ' not found.'])
end
outputFile = tdfread([PATH.FULL '/' FILENAME.VERBAL]);
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
temporalRDMs = cell(INTERVAL-1,1);
for j = 1 : INTERVAL-1;
    temp = nan(size(data,1), param.numUnits.total * param.numCategory.sup);
    for i = 1:size(data,1)
        temp(i,:) = data{i}(j,:);
    end
    timeSliceData{j} = temp;
    temporalRDMs{j} = computeRDM(timeSliceData{j});
end

% now you can compute RDM like so
colormap jet
% imagesc(temporalRDMs{25})

%% compare to the theoritical basic level matrix
basicPatterns = dsum(prototype,prototype);
basicPatterns = dsum(basicPatterns,prototype);
basicRDM = computeRDM(basicPatterns);
superPatterns = dsum(ones(param.numInstances,param.numInstances),ones(param.numInstances,param.numInstances));
superPatterns = dsum(superPatterns,ones(param.numInstances,param.numInstances));
superRDM = computeRDM(superPatterns);
%%
for i = 1 : INTERVAL-1
    temporalCorr.basic(i) = corr(basicRDM(:), temporalRDMs{i}(:));
    temporalCorr.super(i) = corr(superRDM(:), temporalRDMs{i}(:));
end
temporalCorr.basic(isnan(temporalCorr.basic)) = 0; 
temporalCorr.super(isnan(temporalCorr.super)) = 0; 
hold on 
plot(temporalCorr.basic, 'linewidth', 1.5)
plot(temporalCorr.super, 'linewidth', 1.5)
hold off 

legend({'basic theoretical matrix', 'super theoretical matrix'}, 'location', 'southeast', 'fontsize', 14)
title('RDM correlation over time, x presentation', 'fontsize', 14)
xlabel('Time', 'fontsize', 14)
ylabel('Correlation', 'fontsize', 14)
