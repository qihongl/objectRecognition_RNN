function [RDM] = computeRDM(X)
[m,~] = size(X);

RDM = nan(m,m);

for i = 1 : m
    for j = 1 : m 
        RDM(i,j) = 1-corr2(X(i,:),X(j,:));
    end
end

end