%% helper function, either spatial blur or randomly subset the data
function [X, info] = preprocess(X, param)
% input     X: design matrix, stimulus by voxel
% ouput     X: post processed design matrix with a different dimension

if param.subsetProp > 1
    error('ERROR: subset Proportion should be less than 1!')
end

%% pre-process the data
if param.collapseTime
    for t = 1 : length(X)
        % spatial blur or random subset
        [X{t}, info] = preprocess_sup(X{t}, param);
    end
    % collapse all activation matrices over time
    X = cell2mat(X);
else
    % spatial blur or random subset
    [X, info] = preprocess_sup(X, param);
end
end


function [X, info] = preprocess_sup(X, param)
info.condition = param.classOpt; 
% impose normal noise, which simulates "measurement noise"
X = X + param.var * randn(size(X));

if strcmp(param.classOpt,'spatBlurring')
    % determine how many gourps to separate
    nBlurGroups = round(size(X,2) * param.subsetProp);
    n = size(X,2); 
    gpSize = round(n / nBlurGroups); 
    info.bins = genBins(n, gpSize); 
    X_cell = mat2cell(X, size(X,1), info.bins); 
    X = colMeans4cells(X_cell); 
elseif strcmp(param.classOpt,'randomSubset')
    % select random subset of the data
    subset.numUnits = round(size(X,2) * param.subsetProp);
    info.ind = randsample(size(X,2),subset.numUnits);
    X = X(:,info.ind);
else
    error('param.classOpt: unrecognized input!')
end
end


% generate bins for the blurring subsets 
function bins = genBins(total_val, bin_val)
total_val_orig = total_val; 
if total_val < bin_val 
    error('Not enough nFeature to split into subgroups')
end
bins = []; 
while total_val >= bin_val
    total_val = total_val - bin_val;
    bins = horzcat(bins, bin_val); 
end
% attach the remainder 
if total_val ~= 0
    bins = horzcat(bins, total_val); 
end
% verify the correctness 
if sum(bins) ~= total_val_orig
    error('omg')
end
end