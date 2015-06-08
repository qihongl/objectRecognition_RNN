%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category
clear ; close all; clc

%% Specify the Path information
PATH.PROJECT = '/Users/Qihong/Dropbox/github/PDPmodel_Categorization/';
PATH.DATA_FOLDER = 'sim19_twoClasses';

% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'verbalAll_e2.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%% load the data and the prototype
% read the output data
PATH.TEMP = [PATH.PROJECT PATH.DATA_FOLDER];
% check if the data file exists
if exist([PATH.TEMP '/' FILENAME.DATA], 'file') == 0
    error([ 'File ' FILENAME.DATA ' not found.'])
end
outputFile = tdfread([PATH.TEMP '/' FILENAME.DATA]);
name = char(fieldnames(outputFile));
output = getfield(outputFile, name);

% read the prototype pattern, to get some parameters of the simulation
[param, prototype] = readPrototype ([PATH.TEMP '/' FILENAME.PROTOTYPE]);


%% data preprocessing
activationMatrix = getActivationMatrices(output, param);
activationMatrix = attachLabels(activationMatrix, param);
data = activationMatrix; clear activationMatrix;


%% Logistic classifier
numTimePoints = size(data,1);
accuracy = nan(numTimePoints, 1);
% compute the accuracy for all time points
for i = 1 : numTimePoints
    accuracy(i) = logisticReg(data{i});
end

%% plot
plot(accuracy)
fontsize = 18;
xlabel('time', 'FontSize', fontsize)
ylabel('accuracy (%)', 'FontSize', fontsize)
title('logistic regression classifcation accuracy against time', 'FontSize', fontsize)