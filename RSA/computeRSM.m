%% compute representational dissimilarity matrix
% assume the neural responses for all instances are given in X
function [RDM] = computeRSM(X)
[m,~] = size(X);

% preallocate
RDM = nan(m,m);
for i = 1 : m
    for j = 1 : m 
        % compute RDM
        RDM(i,j) = corr2(X(i,:),X(j,:));
    end
end

end