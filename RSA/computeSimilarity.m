function similarity = computeSimilarity(RSM,nCat,len)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
similarity = nan(nCat.bas,nCat.bas,nCat.sup);
% loop over sup class 
for s = 1 : nCat.sup
    for i = 1 : nCat.bas
        % compute the basic instance idx
        idx.row = (1+(i-1)*len.bas):(i*len.bas);
        % shift the idx by sup class
        idx.row = idx.row + len.sup * (s-1);
        for j = 1 : nCat.bas
            % compute the basic instance idx
            idx.col = (1+(j-1)*len.bas):(j*len.bas);
            % shift the idx by sup class
            idx.col = idx.col + len.sup * (s-1);
            
            similarity(i,j,s) = lowTrigMean(RSM(idx.row,idx.col));
%             fprintf('[%s] - [%s] \n',num2str(idx.row),num2str(idx.col))
        end
%         fprintf('\n')
    end
end
end

