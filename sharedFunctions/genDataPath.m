%% connect the paths to get a full data path
% also check if the target file exists (indicated by full path)
function [ fullpath ] = genDataPath(PATH, filename)
% read the output data
fullpath = fullfile(PATH.PROJECT,PATH.SIMID, filename);
% check if the data file exists
if exist(fullpath, 'file') == 0
    error([ 'File ' filename  ' not found.'])
end

end

