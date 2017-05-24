function [result] = evalModel(model, X, y, CVB, param)
if param.subsetProp > 1
    error('ERROR: subset Proportion should be less than 1!')
end

%% pre-process the data
if param.collapseTime
    for t = 1 : length(X)
        % spatial blur or random subset
        X{t} = preprocess(X{t}, param);s
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
    y_hat = glmval(model.beta, X_test, 'logit');
elseif strcmp(param.method,'ridge') 
    y_hat = glmval(model.beta, X_test, 'logit');
elseif strcmp(param.method,'svm');
    y_hat = svmclassify(model.svmStruct,X_test);
else
    error('classification method: unrecognized input')
end
%% compute the mean performance
result.accuracy = sum(round(y_hat) == y_test) / length(y_test);
% deviation = L1 normDiff(prediction values, truth),more sensitive than accuracy
result.deviation = sum(abs(y_hat - y_test)) / length(y_test);
% hit rate and false alarm rate
result.hitRate = sum(y_hat & y_test) / sum(y_test);
result.falseRate = sum(y_hat & ~y_test) / sum(~y_test);

end