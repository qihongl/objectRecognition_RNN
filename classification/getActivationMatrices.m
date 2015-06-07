%% This script obtain the "activation matrix", given the raw data
% It produces a cell array of matrices, arranged along time points. In
% particular, every time point has a activation matrix, each row records
% the neural patterns for one instance

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
prototype = logical(prototype);

% compute the target label (super class label)
target = repmat((1: param.numCategory.sup), [param.numInstances,1]);
% target = target(:); % vectorize the matrix by column 
target = target';


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

% plot the data
for i = 1 : param.numStimuli
    subplot(param.numCategory.sup,param.numInstances,i)
    imagesc(data{i})
end


data = reshape(data, param.numCategory.sup, param.numInstances);

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% From now on, the code assumes BINARY classification
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% set up CV blocks
% k = 4; % determine the number of fold for CV
% numInstances = size(data,1) * size(data,2);
% mod(1:param.numStimuli,k)


%% construct activation matrices for all time points
% Each matrix represents a time point; every row in a matrix represents the
% full network activation of one instance. The goal is to perform super

INTERVAL = INTERVAL - 1;    % the zero row was eliminated
acts = cell(INTERVAL,1);    % pre-allocate

% loop over all time points
for t = 1: INTERVAL
    for i = 1 : param.numStimuli
        % check number of total units
        numTotalUnits = param.numCategory.sup * param.numUnits.total;
        if numTotalUnits ~= size(data{i},2)
            warning('number of total units mismatch');
        end

        % start constructing activation matrices
        temp = nan(param.numInstances, numTotalUnits);
        fprintf('Time: %d \t numInstace: %d\n',t,i)
        temp(i,:) = data{i}(t,:);
    end
    % save the activation matrix
    acts{t} = temp; clear temp;
end 

activationMatrix = acts;
save('activationMatrix')
disp('done!')
