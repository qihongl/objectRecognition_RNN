%% Logistic regression classifier
% it TAKES a data set and a cross-validation block
% it RETURNS the cross-validated accuracy
function [result] = logisticReg(data, CVB, param)

% input validation
if param.subsetProp > 1
    error('ERROR: subset Proportion should be less than 1!')
end

%% obtain the predictors and responses
X = data(:, 1 : (size(data,2) - 1));
y = data(:, size(data,2));

%% pre-process the data
% impose normal noise, which simulates "measurement noise"
X = X + param.var * randn(size(X));
% spatial blur or random subset
X = preprocess(X, param);

%% separate the training and testing sets
X_test = X(CVB,:);
y_test = y(CVB,:);
X_train = X(~CVB,:);
y_train = y(~CVB,:);

%% fit logistic LASSO or SVM
if strcmp(param.method,'lasso')
    [beta, stats] = lassoglm(X_train,y_train,'binomial');
    best_idx = find(min(stats.Deviance) == stats.Deviance,1);
    coef = [stats.Intercept(best_idx); beta(:,best_idx)];
    yhat = glmval(coef, X_test, 'logit');
elseif strcmp(param.method,'ridge')
    [beta, stats] = lassoglm(X_train,y_train,'binomial','Alpha',1e-10);
    best_idx = find(min(stats.Deviance) == stats.Deviance,1);
    coef = [stats.Intercept(best_idx); beta(:,best_idx)];
    yhat = glmval(coef, X_test, 'logit');
elseif strcmp(param.method,'svm')
    svmStruct = svmtrain(X_train, y_train);
    yhat = svmclassify(svmStruct,X_test);
else
    error('classification method: unrecognized input')
end

%% compute the mean performance
% result.accuracy = mean(double(predictedLabels == ytest)) * 100;
result.accuracy = sum(round(yhat) == y_test) / length(y_test);
% deviation = L1 normDiff(prediction values, truth),more sensitive than accuracy
result.deviation = sum(abs(yhat - y_test)) / length(y_test);
% hit rate and false alarm rate
result.hitRate = sum(yhat & y_test) / sum(y_test);
result.falseRate = sum(yhat & ~y_test) / sum(~y_test);

end

% helper function, either spatial blur or randomly subset the data
function X = preprocess(X, param)
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

end