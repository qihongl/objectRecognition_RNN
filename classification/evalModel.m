function [result] = evalModel(model, X, y, CVB, param)
%% separate the training and testing sets
X_test = X(CVB,:);
y_test = y(CVB,:);
X_train = X(~CVB,:);
y_train = y(~CVB,:);

%% fit logistic LASSO or SVM
if strcmp(param.method,'lasso')
    y_hat = glmval(model.beta, X_test, 'logit');
elseif strcmp(param.method,'ridge') 
    y_hat = glmval(model.beta, X_test, 'logit');
elseif strcmp(param.method,'svm');
    y_hat = svmclassify(model.svmStruct,X_test);
else
    error('classification method: unrecognized input')
end

result = computeClassifierPerformance(y_hat, y_test); 

end