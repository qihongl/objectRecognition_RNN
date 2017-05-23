%% prototype generation 
% use minimal units (n) and minimal number of instances (m)
function [proto] = protoFileGen(fname, nActUnits, nSupCat, nLevels)
if nLevels < 2
    error('The number of level must be larger than 2')
end

% generate the parameters
[nUnits, nInstances] = paramGen(nActUnits, nLevels);
% generate the prototype pattern
proto = genProtoType(nInstances, nActUnits, nSupCat, nUnits, nLevels);
% write to a csv file 
writeToFile(fname, proto, nUnits, nSupCat)
% print info
printProtoInfo(proto, nInstances, nActUnits, nSupCat, nUnits);
end

%%%%%%%%%%%%%%%%%%%%%
% helper functions
%%%%%%%%%%%%%%%%%%%%%

%% generate parameters
function [nUnits, nInstances] = paramGen(nActUnits, nLevels)
% compute the number of units designated for each level of concept
nUnits = nActUnits * 2 .^ (0 : nLevels-1);
nInstances = 2^(nLevels-1);
end

%% generate prototype given the parameters
function proto = genProtoType(nInstances, nActUnits, nSupCat, nUnits, nLevels)
% fill in the patterns 
proto = cell(1,nLevels);
proto{1} = ones(nInstances, nUnits(1));
for l = 2 : nLevels
    proto{l} = zeros(nInstances, nUnits(l));
    for i = 0 : nInstances-1
        % compute the starting location of "1"
        idx_start = mod(i, nUnits(l)/nActUnits) * nActUnits + 1;
        proto{l}(i+1, idx_start:(idx_start + nActUnits-1)) = 1;
    end
end
% concatenate across levels to get the prototype within one sup cat
proto = cell2mat(proto); 
% repeat the pattern across sup cats
for i = 1 : nSupCat
    if i == 1
        proto_all = proto;
    else
        proto_all = dsum(proto_all, proto);
    end
end
imagesc(proto_all); 
end

% write to a csv file 
function writeToFile(fname, proto, nUnits, nSupCat)
header = horzcat(nUnits, nSupCat, 2, 2); 
header = horzcat(header, zeros(1,size(proto,2) - length(header))); 
% write
fname = sprintf('%s.csv', fname);
csvwrite(fname,vertcat(header,proto)); 
end

% print info 
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

