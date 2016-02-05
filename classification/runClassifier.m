%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category
function [gs, param, logParams] = runClassifier(showPlot)
if nargin == 0
    showPlot = true;
end
%% Specify the Path information (user needs to do this!)
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% PATH.DATA_FOLDER = 'sim21.5_lessHidden';
PATH.DATA_FOLDER = 'sim16_large';
% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'hiddenAll_e2.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%% set some paramters
showresults = false;

% classOpt = classification options
% 0 -> normal classifcation
% 1 -> classification with Spatial bluring
% 2 -> classifcation with random subset of neurons.
logParams.classOpt = 1;
logParams.numBlurrGroups = 3; 
logParams.subsetProp = 0.1;

% variance of the normal noise
logParams.variance = 0;

% specifiy the number of folds for CV
K = 3;

%% load the data and the prototype
[output, param] = loadData(PATH, FILENAME);

%% data preprocessing
% get activation matrices
activationMatrix = getActivationMatrices(output, param);
numTimePoints = size(activationMatrix,1);
% get labels
[~, Y] = getLabels(param);

% loop over all categories
numCategories = size(Y,2);
for j = 1 : numCategories
    %% attach labels
    data = attachLabels(activationMatrix, Y(:,j));
    %% set up Cross validation blocks
    CVB = logical(mod(1:param.numStimuli,K) == 0);
    
    % preallocation
    accuracy = nan(numTimePoints, 1);
    deviation = nan(numTimePoints, 1);
    response = nan(numTimePoints, 1);
    %% Run Logistic regression classification for all time points
    % loop over time
    for i = 1 : numTimePoints
        % compute the accuracy for every time points
        [accuracy(i), response(i), deviation(i)] = logisticReg(data{i}, CVB, logParams, showresults);
    end
    gs.accuracy{j} = accuracy;
    gs.deviation{j} = deviation;
    gs.response{j} = response;
end

% averaging the neural activities
[gs.averageScore] = averagingResults(gs,numCategories, numTimePoints);

%% A function that visualizes the results
if showPlot
    visualizeAccuracies(gs.averageScore)
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% averaging the results across simulations
function [score] = averagingResults(gs,numSim, numTimePoints)
% preallocate
accuracy = zeros(numTimePoints, 1);
deviation = zeros(numTimePoints, 1);
response =  zeros(numTimePoints, 1);
% accumulate
for i = 1 : numSim
    accuracy = accuracy + gs.accuracy{i};
    deviation = deviation + gs.deviation{i};
    response = response + gs.response{i};
end
% take mean
score.accuracy = accuracy / numSim;
score.deviation = deviation / numSim;
score.response = response / numSim;
end