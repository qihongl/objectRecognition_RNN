%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category


%% Initialization
clear ; close all; clc

%% Load Data
%  The first two columns contains the exam scores and the third column
%  contains the lab
data = load('data.mat');
data = data.activationMatrix;

%% do the 1st time point! LOOP if i want all time points
accuracy = nan(size(data,1),1);
for i = 1:size(data,1)
    partialdata = data{i};
    X = partialdata(: , 1 : (size(partialdata,2) - 1));
    y = partialdata(:, size(partialdata,2));
    
    
    %% Compute Cost and Gradient
    %  Setup the data matrix appropriately, and add ones for the intercept term
    [m, n] = size(X);
    
    % Add intercept term to x and X_test
    X = [ones(m, 1) X];
    
    % Initialize fitting parameters
    initial_theta = zeros(n + 1, 1);
    
    % Compute and display initial cost and gradient
    [cost, grad] = costFunction(initial_theta, X, y);
    
    %% Optimizing using fminunc
    %  In this exercise, you will use a built-in function (fminunc) to find the
    %  optimal parameters theta.
    
    %  Set options for fminunc
    options = optimset('GradObj', 'on', 'MaxIter', 400);
    
    %  Run fminunc to obtain the optimal theta
    %  This function will return theta and the cost
    [theta, cost] = ...
        fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);
    
    
    %% Predict and Accuracies
    % Compute accuracy on our training set
    p = predict(theta, X);
    acc = mean(double(p == y)) * 100;
    
    accuracy(i) = acc;
    fprintf('Train Accuracy: %f\n', acc);
    
end
