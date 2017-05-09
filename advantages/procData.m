%% read raw verbal dynamic data, compute mean bas, sup activation values
function [average, baseline, reactionTime] = procData(data, p, nTimePts, proto)
if p.numStimuli ~= size(data,1) / nTimePts
    error('Data matrix dimension inconsistent with nTps')
end

% generate index matrix (itermNumber x time)
idx.full = reshape(1 : nTimePts * p.numStimuli, [nTimePts,p.numStimuli])';
chunk_size = nTimePts * p.numStimuli / p.numCategory.sup;

% get indices for all basic units and sup units
idxAll = getUnitIdx(p.numUnits, p.numCategory.sup);

%% gather mean activation for each level of category
% preallocate
average.sup = zeros(nTimePts, p.numCategory.sup);
average.bas = zeros(nTimePts, p.numCategory.sup);
baseline.bas = zeros(nTimePts, p.numCategory.sup);
baseline.sup = zeros(nTimePts, p.numCategory.sup);

for c = 1 : p.numCategory.sup
    % SUP activation
    % get the data for "c-th chuck" = c-th sup class
    idxDiag.row = 1 + chunk_size * (c-1): chunk_size * c;
    data_chunk = data(idxDiag.row,:);
    
    % within the c-th chunk_size
    supUnitsRange = (1:p.numUnits.sup) + p.numUnits.total * (c-1);
    
    for i = 1 : p.numInstances
        % - get the the targeted-supUnits activations
        average.sup(:,c) = average.sup(:,c) + mean(data_chunk(idx.full(i,:),supUnitsRange),2);
        % - get the the non-targeted-supUnits activations
        baseline.sup(:,c) = baseline.sup(:,c) + mean(data_chunk(idx.full(i,:), setdiff(idxAll.sup, supUnitsRange)),2);
    end
    
    % BASIC activation
    basClass = reshape(repmat(1:p.numCategory.bas,[p.numCategory.bas,1]),[1,p.numCategory.bas^2]);
    for i = 1 : p.numInstances;
        
        basUnitsIdx = ((1 + p.numUnits.sup*basClass(i)) : (p.numCategory.bas * (basClass(i)+1))) + p.numUnits.total * (c-1);
        
        average.bas(:,c) = average.bas(:,c) + ...
            mean(data_chunk(idx.full(i,:),basUnitsIdx), 2);
        baseline.bas(:,c) = baseline.bas(:,c) + ...
            mean(data_chunk(idx.full(i,:), setdiff(idxAll.bas,basUnitsIdx)), 2);
    end
    
end

% normalize
average.sup = average.sup ./ p.numInstances;
baseline.sup = baseline.sup ./ p.numInstances;
average.bas = average.bas ./ p.numInstances;
baseline.bas = baseline.bas ./ p.numInstances;


% compute "RT"
for i = 1 : p.numStimuli
    % for the i-th stimuli ... 
    % get the corresponding row trange 
    tp_range = ((i-1) * nTimePts +1) : (i * nTimePts);
    response = data(tp_range, :);
    % get the sup and bas categories 
    [cat.sup, cat.bas] = stimuli_idx_to_sup_category(i, p);
    % get the target pattern 
    target = getTargetPattern(cat, i, proto, p); 
    % TODO 
    response = computeResponses(response, target); 
    
    reactionTime(i) = getReactionTime(response); 
end

end

%% helper functions

% get indices for all basic units and sup units
function idxAll = getUnitIdx(nUnits, nSupCat)
idxAll.sup = [];
idxAll.bas = [];
for c = 1 : nSupCat
    idxAll.sup = horzcat(idxAll.sup, (1:nUnits.sup) + nUnits.total * (c-1));
    idxAll.bas = horzcat(idxAll.bas, ((nUnits.sup+1):(nUnits.sup+nUnits.bas)) + nUnits.total * (c-1));
end

end

% get the basic and sup category, given the stimuli idx (row idx)
function [sup_category, bas_category] = stimuli_idx_to_sup_category(idx, p)
% get the sup category of the input
sup_category = ceil(idx / p.numInstances);
% get the basic category of the input
tmp = reshape(repmat(1 : p.numCategory.bas,[p.numCategory.bas,1]), p.numCategory.bas^2,1);
idx2basCat = repmat(tmp, [p.numCategory.sup,1]);
bas_category = idx2basCat(idx);
end

function target = getTargetPattern(cat, i, proto, p)
% preallocate 
nUnitsTotal = p.numUnits.total * p.numCategory.sup; 
target = zeros(1,nUnitsTotal);
% compute the index within a sup category 
idx_within_sup_cat = mod(i-1,p.numInstances)+1;
% get the whole pattern 
target_sub = proto(idx_within_sup_cat,:); 
range_target_sub = ((cat.sup-1) * p.numUnits.total + 1) : cat.sup * p.numUnits.total; 
target(range_target_sub) = target_sub; 
end

% separate the response activity to 3 levels of categories 
function response = computeResponses(response_raw, target)
% constants ... CORRECT BUT BAD PRACTICE! 
nSupTargs = 4;
nBasTargs = 4; 
nSubTargs = 2; 

response.all = response_raw(:,logical(target));
response.sup = response.all(:, 1: nSupTargs); 
response.bas = response.all(:, (nSupTargs+1): (nSupTargs + nBasTargs)); 
response.sub = response.all(:, (nSupTargs + nBasTargs +1) : (nSupTargs + nBasTargs + nSubTargs)); 

end

% get response time
function rt = getReactionTime(response)
% for sup cat 
rt.sup = find(mean(response.sup,2) == max(mean(response.sup,2)),1); 
% for bas cat 
rt.bas = find(mean(response.bas,2) == max(mean(response.bas,2)),1); 
% for sub cat 
rt.sub = find(mean(response.sub,2) == max(mean(response.sub,2)),1); 
end
