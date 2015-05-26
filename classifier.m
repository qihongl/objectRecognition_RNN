%% superordinate level classifier
% the goal of this program is to convert a 'neural response' from ANN (in
% the form of a time series) and outputs a 'class' that represents a
% superordinate level category

clear;clc;clf;
%% Path information
PATH.PROJECT = '/Users/Qihong/Dropbox/github/PDPmodel_Categorization/';
PATH.DATA_FOLDER = 'sim16.1_large';

% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'verbalAll_e1.txt';
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
[numUnits, numCategory, numInstances, prototype] = readPrototype ([PATH.TEMP '/' FILENAME.PROTOTYPE]);
numStimuli = numInstances * numCategory.sup;
prototype = logical(prototype);
