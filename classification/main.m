%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category
clear ; close all; clc

%% Specify the Path information (user needs to do this!)
PATH.PROJECT = '/Users/Qihong/Dropbox/github/PDPmodel_Categorization/';
PATH.DATA_FOLDER = 'sim16_large';
% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'verbalAll_e05.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%% set some paramters
% specificy the target class
% this doesn't matter for binary classification
% for multiclass-classification, you might want to loop over all target! 
TARGET = 1; 
% specifiy the number of folds for CV
K = 3;

%% load the data and the prototype
[output, param] = loadData(PATH, FILENAME);

%% data preprocessing
% get activattion matrices
activationMatrix = getActivationMatrices(output, param);
% get labels
[~, Y] = getLabels(param);

% attach labels
activationMatrix = attachLabels(activationMatrix, Y(:,TARGET));

% change to a simpler name... 
data = activationMatrix; clear activationMatrix;


%% Cross validation 
% set up the CV blocks
CVB = logical(mod(1:param.numStimuli,K) == 0);

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
ylabel('cross-validated accuracy (%)', 'FontSize', fontsize)
title('logistic regression: accuracy against time', 'FontSize', fontsize)