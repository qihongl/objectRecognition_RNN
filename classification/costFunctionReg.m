function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples
n = size(X,2);

h = sigmoid(X * theta);

J = ((1/m) * sum((-y) .* log(h) - (1 - y) .* log(1 - h)))...
    + (lambda / (2 * m)) * sum(theta(2:n,:) .^2);

grad(1,:) = (1 / m) * (X(:,1)' * (h - y));
grad(2:n,:) = ((1 / m) * (X(:,2:n)' * (h - y)))...
    + theta(2:n,:) * (lambda / m);


end
