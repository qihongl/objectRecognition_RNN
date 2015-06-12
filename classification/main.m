%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category
clear ; close all; clc

%% Specify the Path information
PATH.PROJECT = '/Users/Qihong/Dropbox/github/PDPmodel_Categorization/';
PATH.DATA_FOLDER = 'sim19_twoClasses';
% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'verbalAll_e05.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%% load the data and the prototype
[output, param] = loadData(PATH, FILENAME);

%% data preprocessing
% get activattion matrices
activationMatrix = getActivationMatrices(output, param);
% get labels
[~, Y] = getLabels(param);

% attach labels
activationMatrix = attachLabels(activationMatrix, Y(:,2));

% change to a simpler name... 
data = activationMatrix; clear activationMatrix;


%% Cross validation 
% set up the CV blocks
k = 2;
CVB = logical(mod(1:param.numStimuli,k) == 0);

%% Run Logistic regression classification 
numTimePoints = size(data,1);       % preallocation
accuracy = nan(numTimePoints, 1);   % preallocation
% loop over time
for i = 1 : numTimePoints
    % compute the accuracy for every time points
    accuracy(i) = logisticReg(data{i}, CVB);
end


%% Plot the CV accuracies against time
plot(accuracy)
fontsize = 18;
xlabel('time', 'FontSize', fontsize)
ylabel('accuracy (%)', 'FontSize', fontsize)
title('logistic regression classifcation accuracy against time', 'FontSize', fontsize)