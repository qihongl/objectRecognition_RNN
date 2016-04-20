function [ meanSpread ] = getSpread( data, param, idx, nTimePts )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% preallocate 
catSize.sup = param.numStimuli / param.numCategory.sup;
catSize.bas = param.numStimuli /param.numCategory.sup /param.numCategory.bas;
path = cell(catSize.sup,1);
meanPath.sup = zeros(nTimePts, size(data,2));
meanPath.bas = zeros(nTimePts, size(data,2));
meanPath.all = zeros(nTimePts, size(data,2));
spread.sup = zeros(size(meanPath.sup));
spread.bas = zeros(size(meanPath.sup));
meanSpread.sup.within = zeros(size(meanPath.sup));
meanSpread.sup.bet = zeros(size(meanPath.sup));
meanSpread.bas.within = zeros(size(meanPath.sup));
meanSpread.bas.bet = zeros(size(meanPath.sup));

%% get all path
for i = 1 : param.numStimuli
    path{i} = data(idx(i,:),:);
    meanPath.all = meanPath.all + path{i};
end
meanPath.all = meanPath.all / param.numStimuli;


%% compute the spread of the sup category 
for j = 1 : param.numCategory.sup
    % sup
    for i = (1 + catSize.sup * (j-1)) : catSize.sup * j
        meanPath.sup = meanPath.sup + path{i};
    end
    % compute average path in semantic space
    meanPath.sup = meanPath.sup / catSize.sup;
    temp{j} = meanPath.sup;
    % get the spread between different super categories 
    meanSpread.sup.bet = meanSpread.sup.bet + abs(meanPath.sup - meanPath.all);
%     meanSpread.sup.bet = meanSpread.sup.bet + abs(meanPath.sup);
    
    % sum the spread of the individual path to the average path
    for i = 1 : catSize.sup
        spread.sup = spread.sup + abs(path{i} - meanPath.sup);
    end
    % get the mean spread for one superordinate class
    meanSpread.sup.within = meanSpread.sup.within + spread.sup;
end
% compute the mean spread.sup across sup category
meanSpread.sup.within = meanSpread.sup.within / param.numCategory.sup;
meanSpread.sup.bet = meanSpread.sup.bet / param.numCategory.sup;




%% compute the spread of the bas category 
tempIdx = reshape(repmat(1:3,[4,1]),[1,12]);


for j = 1 : param.numCategory.sup*param.numCategory.bas
    for i = (1 + catSize.bas * (j-1)) : catSize.bas * j
        meanPath.bas = meanPath.bas + path{i};
    end
    % compute average path in semantic space
    meanPath.bas = meanPath.bas / catSize.bas;
    % get the spread between class
    meanSpread.bas.bet = meanSpread.bas.bet + abs(meanPath.bas - temp{tempIdx(j)});
    
    % sum the spread.sup of the individual path to the average path
    for i = 1 : catSize.bas
        spread.bas = spread.bas + abs(path{i} - meanPath.bas);
    end
    % get the mean spread for one superordinate class
    meanSpread.bas.within = meanSpread.bas.within + spread.bas;
end
% compute the mean spread across sup category
meanSpread.bas.within = meanSpread.bas.within / (param.numCategory.sup*param.numCategory.bas);
meanSpread.bas.bet = meanSpread.bas.bet/ (param.numCategory.sup*param.numCategory.bas);
end

