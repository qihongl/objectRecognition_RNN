%% Logistic regression classifier
% it TAKES a data set and a cross-validation block
% it RETURNS the cross-validated accuracy
function [result] = logisticReg(data, CVB, param, showresults)

% input validation
if param.subsetProp > 1
    error('ERROR: subset Proportion should be less than 1!')
end

%% obtain the predictors and responses
X = data(: , 1 : (size(data,2) - 1));
y = data(:, size(data,2));
param.numUnits = size(X,2);

%% pre-process the data in accordance to the "classification option"
if strcmp(param.classOpt,'spatBlurring')
    % determine how many gourps to separate
    numBlurrGroups = round(size(X,2) * param.subsetProp);
    
    if numBlurrGroups > 1
        subset.gpSize = round(size(X,2) / numBlurrGroups);
        for n = 1 : numBlurrGroups-1
            % select a subset (columns) of X
            subset.ind = randsample(size(X,2), subset.gpSize);
            % compute logical indices for selected units
            tempLogic = false(size(X,2),1); tempLogic(subset.ind) = true;
            % select the units
            subset.X{n} = X(:,tempLogic);
            % delete selected units (columns) in X
            X = X(:,~tempLogic);
        end
        % collect the remaining columns in X
        subset.X{size(subset.X,2) + 1 } = X;
        % re-compute blurred X
        clear X;
        for n = 1 : numBlurrGroups
            X(:,n) = mean(subset.X{n},2);
        end
    else % if there is only one group 
        X = mean(X,2);
    end
    
elseif strcmp(param.classOpt,'randomSubset')
    % select random subset of the data
    subset.numUnits = round(size(X,2) * param.subsetProp);
    subset.ind = randsample(size(X,2),subset.numUnits);
    X = X(:,subset.ind);
else
    warning('param.classOpt: unrecognized input!')
end

%% separate the training and testing sets
Xtest = X(CVB,:);
ytest = y(CVB,:);
Xtrain = X(~CVB,:);
ytrain = y(~CVB,:);

%% Compute Cost and Gradient using fminunc
%  Setup the data matrix appropriately, and add ones for the intercept term
[m, n] = size(Xtrain);
% Add the intercept term to the design matrix
Xtrain = [ones(m, 1) Xtrain];

% Initialize fitting parameters and options
initial_beta = zeros(n + 1, 1);
options = optimset('GradObj', 'on', 'MaxIter', 400);
%  Run fminunc to obtain the optimal beta
if showresults
    disp('Weights estimation in progress...')
end
beta = fminunc(@(t)(costFunction(t, Xtrain, ytrain)), initial_beta, options);

%% Predict and Accuracies
% compute the prediction
Xtest = [ones(size(Xtest,1), 1) Xtest]; % add the intercept term
rawPrediction = sigmoid(Xtest * beta);
predictedLabels  = rawPrediction >= 0.5;

%% compute the mean performance 
result.accuracy = mean(double(predictedLabels == ytest)) * 100;

% deviation = L1 normDiff(prediction values, truth),more sensitive than accuracy
result.deviation = sum(abs(rawPrediction - ytest)) / length(rawPrediction);
result.response = mean([mean(rawPrediction(logical(ytest))), (1-mean(rawPrediction(~logical(ytest)))) ]);

% hit rate and false alarm rate
result.hitRate = sum(predictedLabels & ytest) / sum(ytest);
result.falseRate = sum(predictedLabels & ~ytest) / sum(~ytest);

% %% show the results
if showresults
%     % print the comparison between model response and the truth
%     [rawPrediction , ytest]
%     % Compute accuracy on our training set
%     fprintf('Cross-validated Accuracy: %.3f\n', result.accuracy);
%     disp('Done!')
end

end



