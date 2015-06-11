%% Logistic regression classifier
function accuracy = logisticReg(data, CVB)
    %% obtain X and Y
    X = data(: , 1 : (size(data,2) - 1));
    y = data(:, size(data,2));   
    
    %% separate the train and test sets
    Xtest = X(CVB,:);
    ytest = y(CVB,:);
    Xtrain = X(~CVB,:);
    ytrain = y(~CVB,:);
    
    %% Compute Cost and Gradient using fminunc
    %  Setup the data matrix appropriately, and add ones for the intercept term
    [m, n] = size(Xtrain);
    
    % Add intercept term to the design matrix
    Xtrain = [ones(m, 1) Xtrain];
    Xtest = [ones(size(Xtest,1), 1) Xtest];
    
    % Initialize fitting parameters
    initial_beta = zeros(n + 1, 1);
    %  Set options for fminunc
    options = optimset('GradObj', 'on', 'MaxIter', 400);
    
    %  Run fminunc to obtain the optimal beta
    %  This function will return beta and the cost
    [beta, cost] = ...
        fminunc(@(t)(costFunction(t, Xtrain, ytrain)), initial_beta, options);
    
    
    %% Predict and Accuracies
    
    % compute the prediction
    p  = sigmoid(Xtest * beta) >= 0.5; 
    
    % Compute accuracy on our training set
    accuracy = mean(double(p == ytest)) * 100;
    fprintf('Train Accuracy: %f\n', accuracy);
    
end
