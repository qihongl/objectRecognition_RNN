%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category
function [gs, gs_dc, data_param] = runClassifier(param,PATH,FILENAME,showPlot)
if nargin == 0
    showPlot = true;
end

%% load the data and the prototype
[output, data_param] = loadData(PATH, FILENAME);

%% data preproc
% get X, Y
actMats = getActivationMatrices(output, data_param);
[~, Y] = getLabels(data_param);

% specifiy the number of folds for CV
K = 3;
numCategories = size(Y,2);

%% MVPA
if param.collapseTime
    for j = 1 : numCategories
        CVB = logical(mod(1:data_param.numStimuli,K) == 0);
        gs = logisticReg(actMats', Y(:,j), CVB, param);
    end
else
    
    % check the number of time points
    nTimePts = size(actMats,1);
    if nTimePts~=param.nTimePoints
        error('numTimePoints is %d(incorrect)!', nTimePts);
    end
    
    % preallocate for the dynamic code analysis
    gs_dc = cell(nTimePts, numCategories);
    
    % 1. regular classification
    for j = 1 : numCategories
        %% set up Cross validation blocks
        CVB = logical(mod(1:data_param.numStimuli,K) == 0);
        % preallocation
        accuracy = nan(nTimePts, 1);
        deviation = nan(nTimePts, 1);
        hitRate = nan(nTimePts, 1);
        falseRate = nan(nTimePts, 1);
        %% Run Logistic regression classification for all time points
        % loop over time
        for t = 1 : nTimePts
            [X, info] = preprocess(actMats{t}, param);
            % compute the accuracy for every time points
            result = logisticReg(X, Y(:,j), CVB, param);
            accuracy(t) = result.accuracy;
            deviation(t) = result.deviation;
            hitRate(t) = result.hitRate;
            falseRate(t) = result.falseRate;
            
            % 2. analysis - dynamic code
            if param.dynamicCode
                % run the classification with fixed model over all tps
                result_dc = evalModel_forAllTps(result, Y(:,j), actMats, CVB, param, nTimePts, info);
                gs_dc{t,j} = summarizeResultsOverTime(result_dc);
            end
        end
        gs.accuracy{j} = accuracy;
        gs.deviation{j} = deviation;
        gs.hitRate{j} = hitRate;
        gs.falseRate{j} = falseRate;
        
    end
    % averaging the results
    gs.averageScore = averagingResults(gs,numCategories, nTimePts);
end

%% A function that visualizes the results
if showPlot
    visualizeAccuracies(gs.averageScore)
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% averaging the results across simulations
function [score] = averagingResults(gs,numCategories, numTimePoints)
% preallocate
accuracy = zeros(numTimePoints, 1);
deviation = zeros(numTimePoints, 1);
hitRate =  zeros(numTimePoints, 1);
falseRate =  zeros(numTimePoints, 1);

% accumulate
for i = 1 : numCategories
    accuracy = accuracy + gs.accuracy{i};
    deviation = deviation + gs.deviation{i};
    hitRate = hitRate  + gs.hitRate{i};
    falseRate = falseRate + gs.falseRate{i};
end

% take mean
score.accuracy = accuracy / numCategories;
score.deviation = deviation / numCategories;
score.hitRate = hitRate / numCategories;
score.falseRate = falseRate / numCategories;
end

%% gather data from the dynamic code analaysis
function r = summarizeResultsOverTime(result_dc)
% preallocate
nTps = length(result_dc);
r.accuracy = nan(nTps,1);
r.deviation = nan(nTps,1);
r.hitRate = nan(nTps,1);
r.falseRate = nan(nTps,1);

% gather data
for t = 1 : nTps
    r.accuracy(t) = result_dc{t}.accuracy;
    r.deviation(t) = result_dc{t}.deviation;
    r.hitRate(t) = result_dc{t}.hitRate;
    r.falseRate(t) = result_dc{t}.falseRate;
end
end


%% eval model for all time pts
function result = evalModel_forAllTps(model, Y, Xs, CVB, param, nTimePts, info)
result = cell(nTimePts,1);
% run the classification with fixed model over all tps
for t = 1 : nTimePts
    X = preprocess_rep(Xs{t}, info, param.classOpt); 
    result{t} = evalModel(model, X, Y, CVB, param);
end
end