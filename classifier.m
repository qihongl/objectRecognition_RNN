%% superordinate level classifier
% the goal of this program is to convert a 'neural response' from ANN (in
% the form of a time series) and outputs a 'class' that represents a
% superordinate level category

clear;clc;
%% Path information
PATH.PROJECT = '/Users/Qihong/Dropbox/github/PDPmodel_Categorization/';
PATH.DATA_FOLDER = 'sim15_repPrev';

% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'verbalAll_e3.txt';
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
prototype = logical(prototype);

% compute the target label (super class label)
target = repmat((1: param.numCategory.sup), [param.numInstances,1]);
target = target(:); % vectorize the matrix by column 


%% preprocessing
% add a zero row at the beginning so that every pattern has equal numRows
INTERVAL = 26;
output = vertcat( zeros(1,size(output,2)), output);
% split the data
data = mat2cell(output, repmat(INTERVAL, [1 param.numStimuli]), size(output,2) );
for i = 1 : size(data,1)
    data{i} = data{i}(:, 3:end);    % remove the 1st & 2nd columns
    data{i} = data{i}(2:end,:);     % remove the 1st row of zeros
end

% % plot the data
% for i = 1 : param.numStimuli
%     subplot(param.numCategory.sup,param.numInstances,i)
%     imagesc(data{i})
% end

%% perform the classification
% X: data 
% Y: target
% CVBLOCKS




disp('done!')



