% calculate the column-wise mean for each cell
function means = colMeans4cells(cells)
means = nan(size(cells{1},1), length(cells)); 
for i = 1 : length(cells)
    means(:,i) = mean(cells{i},2); 
end
end