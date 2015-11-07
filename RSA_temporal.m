%% plot the temporal dynamics of the model behavior
% this program relies on the output file of 'testAllActs'
% it is designed to process the output for the verbal representation layer

% MORE ABOUT THE EXPERIEMENT:
% the model sees the visual representation for all objects, and its verbal
% patterns were recorded.

%% CONSTANTS
clear;clc;clf;
PATH.ABS = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
PATH.DATA= 'sim22.0_RSVP';
FILENAME.VERBAL = 'verbalAll_e3.txt';
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