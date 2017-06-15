function X_rep = preprocess_rep(X, info, condition)
% re generate X subset
if strcmp(condition, 'randomSubset')
    X_rep = X(:,info.ind);
elseif strcmp(condition, 'spatBlurring')
    cells = mat2cell(X, size(X,1), info.bins);
    X_rep = colMeans4cells(cells);
else
    error('unrecognized condition!')
end
end

