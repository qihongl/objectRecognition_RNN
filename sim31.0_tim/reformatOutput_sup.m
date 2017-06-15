function [] = reformatOutput_sup(fname_data, fname_out)
% constants
nTps = 21;
nObjs = 90;

fid = fopen(fname_data);
listOfStrs = cell(nObjs*nTps,1);
listOfStrs_idx = 1;

% read the output file line by line
while true
    tline = fgets(fid);
    if tline == -1
        break
    end
    strs = strsplit(tline,' ');
    % collect only the naming trial output patterns
    if ~isNaming(strs)
        continue;
    else
        % save the trimed string
        listOfStrs{listOfStrs_idx} = trim(strs);
        listOfStrs_idx = listOfStrs_idx + 1;
    end
end
fclose(fid);

% save the list of strs to a new output file
write2file(fname_out, listOfStrs, nTps);
end


% determine if the current pattern is generated from a naming trial
function isnaming = isNaming(strs)
isnaming = true;
identifier_idx = 2;
identifier = 'N';
trial_name = strs{identifier_idx};
if strcmp(trial_name(length(trial_name)), identifier)
    isnaming = false;
end
end

% trim the name and the last element
function strs = trim(strs)
strs(2) = [] ;
strs(length(strs)) = [];
end

function write2file(fname_out, listOfStrs, nTps)
% if file exists, overwrite
if exist(fname_out, 'file')==2
    fprintf('The file %s is deleted and re-written!', fname_out);
    delete(fname_out);
end
% write new output file
fid = fopen(fname_out,'w');
t_cur = 0;
for i = 1 : length(listOfStrs)
    if mod(t_cur + i, nTps) == 1;
        fprintf(fid,getZeroVec(length(listOfStrs{i})));
    end
    line = cell2string(listOfStrs{i});
    fprintf(fid,line);
end
fclose(fid);
end

function line = cell2string(cellOfStrs)
line = '';
for i = 1 : length(cellOfStrs)
    line = [line cellOfStrs{i} ' '];
end
line = [line '\n'];
end


function zeroVec = getZeroVec(n)
zeroVec = '';
for i = 1 : n
    if i <= 2
        zeroVec = [zeroVec '0' ' '];
    else
        zeroVec = [zeroVec '0.00' ' '];
    end
end
zeroVec = [zeroVec '\n'];
end