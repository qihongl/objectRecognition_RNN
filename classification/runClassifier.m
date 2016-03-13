%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category
function [gs, param] = runClassifier(logParam,PATH,FILENAME,showPlot)
if nargin == 0
    showPlot = true;
end

%% set some paramters
showresults = false;

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
    hitRate = nan(numTimePoints, 1);
    falseRate = nan(numTimePoints, 1);
    %% Run Logistic regression classification for all time points
    % loop over time
    for i = 1 : numTimePoints
        % compute the accuracy for every time points
        result = logisticReg(data{i}, CVB, logParam, showresults);
        accuracy(i) = result.accuracy;
        response(i) = result.response;
        deviation(i) = result.deviation;
        hitRate(i) = result.hitRate;
        falseRate(i) = result.falseRate;
    end
    gs.accuracy{j} = accuracy;
    gs.deviation{j} = deviation;
    gs.response{j} = response;
    gs.hitRate{j} = hitRate;
    gs.falseRate{j} = falseRate;
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
hitRate =  zeros(numTimePoints, 1);
falseRate =  zeros(numTimePoints, 1);

% accumulate
for i = 1 : numSim
    accuracy = accuracy + gs.accuracy{i};
    deviation = deviation + gs.deviation{i};
    response = response + gs.response{i};
    hitRate = hitRate  + gs.hitRate{i};
    falseRate = falseRate + gs.falseRate{i};
end

% take mean
score.accuracy = accuracy / numSim;
score.deviation = deviation / numSim;
score.response = response / numSim;
score.hitRate = hitRate / numSim;
score.falseRate = falseRate / numSim; 
end