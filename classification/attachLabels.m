%% attach appropriate response variable Y to the data set

% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category

clear;clc;
%% Path information
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
load('activationMatrix.mat')



%% attach Y 
% load the data
load('activationMatrix.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% assume binary classifcation! This would not generalize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = [ones(param.numInstances,1); zeros(param.numInstances,1)];

for i = 1 : size(activationMatrix,1)
    activationMatrix{i} = [activationMatrix{i}, y];
end

save('data', 'activationMatrix')
