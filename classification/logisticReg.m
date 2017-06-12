%% Logistic regression classifier
% it TAKES a data set and a cross-validation block
% it RETURNS the cross-validated accuracy
function [result] = logisticReg(X, y, CVB, param)
% input     X: a matrix (or a cell of matrix if collapse time)
%           y: the label vector
%           CVB: cv indices for the test set
%           param: parameters
% output    result: records the classification results and weights

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

result = computeClassifierPerformance(y_hat, y_test, result); 
end