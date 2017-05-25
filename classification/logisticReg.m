%% Logistic regression classifier
% it TAKES a data set and a cross-validation block
% it RETURNS the cross-validated accuracy
function [result] = logisticReg(X, y, CVB, param)
% input     X: a matrix (or a cell of matrix if collapse time)
%           y: the label vector
%           CVB: cv indices for the test set
%           param: parameters
% output    result: records the classification results and weights

if param.subsetProp > 1
    error('ERROR: subset Proportion should be less than 1!')
end


%% pre-process the data
if param.collapseTime
    for t = 1 : length(X)
        % spatial blur or random subset
        X{t} = preprocess(X{t}, param);
    end
    % collapse all activation matrices over time
    X = cell2mat(X);
else
    % spatial blur or random subset
    X = preprocess(X, param);
end


%% separate the training and testing sets
X_test = X(CVB,:);
y_test = y(CVB,:);
X_train = X(~CVB,:);
y_train = y(~CVB,:);

%% fit logistic LASSO or SVM
if strcmp(param.method,'lasso')
    %     options.alpha = 1;
    %     cvfit = cvglmnet(X_train,y_train,'binomial', options, 'auc');
    %     y_hat = cvglmnetPredict(cvfit,X_test, cvfit.lambda_min);
    %     % get the best beta
    %     best_idx = cvfit.lambda_min == cvfit.lambda;
    %     beta = cvfit.glmnet_fit.beta(:,best_idx);
    
    [beta, stats] = lassoglm(X_train,y_train,'binomial');
    best_idx = find(min(stats.Deviance) == stats.Deviance,1);
    result.beta = [stats.Intercept(best_idx); beta(:,best_idx)];
    y_hat = glmval(result.beta, X_test, 'logit');
elseif strcmp(param.method,'ridge')
    %     options.alpha = 0;
    %     cvfit = cvglmnet(X_train,y_train,'binomial', options);
    %     y_hat = cvglmnetPredict(cvfit,X_test, cvfit.lambda_min);
    %     % get the best beta
    %     best_idx = cvfit.lambda_min == cvfit.lambda;
    %     beta = cvfit.glmnet_fit.beta(:,best_idx);
    
    [beta, stats] = lassoglm(X_train,y_train,'binomial','Alpha',1e-4);
    best_idx = find(min(stats.Deviance) == stats.Deviance,1);
    result.beta = [stats.Intercept(best_idx); beta(:,best_idx)];
    y_hat = glmval(result.beta, X_test, 'logit');
    
elseif strcmp(param.method,'svm')
    svmStruct = svmtrain(X_train, y_train);
    y_hat = svmclassify(svmStruct,X_test);
    result.svmStruct = svmStruct; 
else
    error('classification method: unrecognized input')
end

%% compute the mean performance
% result.accuracy = mean(double(predictedLabels == ytest)) * 100;
result.accuracy = sum(round(y_hat) == y_test) / length(y_test);
% deviation = L1 normDiff(prediction values, truth),more sensitive than accuracy
result.deviation = sum(abs(y_hat - y_test)) / length(y_test);
% hit rate and false alarm rate
result.hitRate = sum(y_hat & y_test) / sum(y_test);
result.falseRate = sum(y_hat & ~y_test) / sum(~y_test);
end