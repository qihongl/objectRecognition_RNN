%% helper function, either spatial blur or randomly subset the data
function X = preprocess(X, param)
% input     X: design matrix, stimulus by voxel
% ouput     X: post processed design matrix with a different dimension

% impose normal noise, which simulates "measurement noise"
X = X + param.var * randn(size(X));

if strcmp(param.classOpt,'spatBlurring')
    % determine how many gourps to separate
    numBlurrGroups = round(size(X,2) * param.subsetProp);
    
    if numBlurrGroups > 1
        subset.gpSize = round(size(X,2) / numBlurrGroups);
        for n = 1 : numBlurrGroups-1
            % select a subset (columns) of X
            subset.ind = randsample(size(X,2), subset.gpSize);
            % compute logical indices for selected units
            tempLogic = false(size(X,2),1); tempLogic(subset.ind) = true;
            % select the units
            subset.X{n} = X(:,tempLogic);
            % delete selected units (columns) in X
            X = X(:,~tempLogic);
        end
        % collect the remaining columns in X
        subset.X{size(subset.X,2) + 1 } = X;
        % re-compute blurred X
        clear X;
        for n = 1 : numBlurrGroups
            X(:,n) = mean(subset.X{n},2);
        end
    else % if there is only one group
        X = mean(X,2);
    end
    
elseif strcmp(param.classOpt,'randomSubset')
    % select random subset of the data
    subset.numUnits = round(size(X,2) * param.subsetProp);
    subset.ind = randsample(size(X,2),subset.numUnits);
    X = X(:,subset.ind);
else
    warning('param.classOpt: unrecognized input!')
end

end