function [output, param] = loadData(PATH, FILENAME)

%% load the data and the prototype
% read the output data
path_temp = fullfile(PATH.PROJECT, PATH.DATA_FOLDER, sprintf('%.2d', PATH.rep_idx) ,FILENAME.DATA);
% check if the data file exists
if exist(path_temp, 'file') == 0
    error([ 'File ' path_temp ' not found.'])
end
outputFile = tdfread(path_temp);
name = char(fieldnames(outputFile));
output = getfield(outputFile, name);
% read the prototype pattern, to get some parameters of the simulation
[param, ~] = readPrototype(fullfile(PATH.PROJECT,PATH.DATA_FOLDER,FILENAME.PROTOTYPE));

end