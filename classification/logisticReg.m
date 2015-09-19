%% Logistic regression classifier
% it TAKES a data set and a cross-validation block
% it RETURNS the cross-validated accuracy
function [accuracy, deviation] = logisticReg(data, CVB, variance, spaBlur, showresults)
%% obtain the predictors and responses
X = data(: , 1 : (size(data,2) - 1));
y = data(:, size(data,2));

%% injecting normal noise (this might be important!)
X = X + normrnd(0,variance, size(X));
if spaBlur
    X = mean(X,2);
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
    disp('Parameter estimation in progress...')
end
beta = fminunc(@(t)(costFunction(t, Xtrain, ytrain)), initial_beta, options);

%% Predict and Accuracies
% compute the prediction
Xtest = [ones(size(Xtest,1), 1) Xtest]; % add the intercept term
response = sigmoid(Xtest * beta);
p  = response >= 0.5;

% compute the deviation from the truth, this is more sensitive than
% accuracy, as it has no rounding
deviation = sum(abs(response - ytest));
accuracy = mean(double(p == ytest)) * 100;

if showresults
    % print the comparison between model response and the truth
    [response , ytest]
    % Compute accuracy on our training set    
    fprintf('Cross-validated Accuracy: %.3f\n', accuracy);
    disp('Done!')
end

end



