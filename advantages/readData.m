%% read raw verbal dynamic data, compute mean bas, sup activation values
function [average, baseline] = readData( data, p, nTimePts )

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

end

%% get indices for all basic units and sup units
function idxAll = getUnitIdx(nUnits, nSupCat)
idxAll.sup = [];
idxAll.bas = [];
for c = 1 : nSupCat
    idxAll.sup = horzcat(idxAll.sup, (1:nUnits.sup) + nUnits.total * (c-1));
    idxAll.bas = horzcat(idxAll.bas, ((nUnits.sup+1):(nUnits.sup+nUnits.bas)) + nUnits.total * (c-1));
end

end

