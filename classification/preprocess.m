%% helper function, either spatial blur or randomly subset the data
function X = preprocess(X, param)
% input     X: design matrix, stimulus by voxel
% ouput     X: post processed design matrix with a different dimension

if param.subsetProp > 1
    error('ERROR: subset Proportion should be less than 1!')
end

%% pre-process the data
if param.collapseTime
    for t = 1 : length(X)
        % spatial blur or random subset
        X{t} = preprocess(X{t}, param);
    end
    % collapse all activation matrices over time
    X = cell2mat(X);
else
    % spatial blur or random subset
    X = preprocess(X, param);
end

end


function preprocess_support(X, param)

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