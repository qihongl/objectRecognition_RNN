%% Logistic regression classifier
function accuracy = logisticReg(data)
    %% obtain X and Y
    X = data(: , 1 : (size(data,2) - 1));
    y = data(:, size(data,2));    
    
    %% Compute Cost and Gradient using fminunc
    %  Setup the data matrix appropriately, and add ones for the intercept term
    [m, n] = size(X);
    
    % Add intercept term to x and X_test
    X = [ones(m, 1) X];
    
    % Initialize fitting parameters
    initial_theta = zeros(n + 1, 1);
    
    %  Set options for fminunc
    options = optimset('GradObj', 'on', 'MaxIter', 400);
    
    %  Run fminunc to obtain the optimal theta
    %  This function will return theta and the cost
    [theta, cost] = ...
        fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);
    
    
    %% Predict and Accuracies
    % Compute accuracy on our training set
    p = predict(theta, X);
    accuracy = mean(double(p == y)) * 100;
    fprintf('Train Accuracy: %f\n', accuracy);
end

