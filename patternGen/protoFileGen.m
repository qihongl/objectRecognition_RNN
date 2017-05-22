function [proto] = protoFileGen(nActUnits, nSupCat, nLevels)
if nLevels < 2 
    error('The number of level must be larger than 2')
end

nInstances = 4;
% generate the parameters 
nUnits = paramGen(nActUnits, nLevels);
% generate the prototype pattern
proto = genProtoType(nInstances, nActUnits, nSupCat, nUnits); 
% print info 
printProtoInfo(proto, nInstances, nActUnits, nSupCat, nUnits);
end

%% helper functions 

%% generate parameters
function nUnits = paramGen(nActUnits, nLevels)
% compute the number of units designated for each level of concept
nUnits = nActUnits * 2 .^ (0 : nLevels-1); 
end

%% generate prototype given the parameters 
function proto_all = genProtoType(nInstances, nActUnits, nSupCat, nUnits)
% fill in the pattern - sup
proto.sup = ones(nInstances, nUnits(1));

% fill in the pattern - bas
proto.bas = zeros(nInstances, nUnits(2));
for i = 0 : nInstances-1
    % compute the starting location of "1"
    idx_start = mod(i, nUnits(2)/nActUnits) * nActUnits + 1;
    proto.bas(i+1, idx_start:(idx_start + nActUnits-1)) = 1;
end

% fill in the pattern - sub
proto.sub = zeros(nInstances, nUnits(3));
for i = 0 : nInstances-1
    idx_start = mod(i, nUnits(3)/nActUnits) * nActUnits + 1;
    proto.sub(i+1, idx_start:(idx_start + nActUnits-1)) = 1;
end

% concatenate across levels to get the prototype within one sup cat 
proto = horzcat(proto.sup, proto.bas, proto.sub); 

% repeat the pattern across sup cats
for i = 1 : nSupCat
    if i == 1
        proto_all = proto; 
    else
        proto_all = dsum(proto_all, proto); 
    end
end

end

function printProtoInfo(proto, nInstances, nActUnits, nSupCat, nUnits)
fprintf('Summary:\n')
fprintf('nUnits of the input layer = %d\n', size(proto,2))
fprintf('nInstances total = %d\n', size(proto,1))
fprintf('---\n')
fprintf('nInstances for each sup = %d\n', nInstances)
fprintf('nActivated Units = %d\n', nActUnits)
fprintf('nSupCat  = %d\n', nSupCat)
fprintf('nUnitsEachSup = %d\n', sum(nUnits))

end