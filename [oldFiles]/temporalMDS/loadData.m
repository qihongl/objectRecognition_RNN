function [output, param] = loadData(PATH, FILENAME)

%% load the data and the prototype
% read the output data
PATH.TEMP = [PATH.PROJECT PATH.DATA_FOLDER];
% check if the data file exists
if exist([PATH.TEMP '/' FILENAME.DATA], 'file') == 0
    error([ 'File ' FILENAME.DATA ' not found.'])
end
outputFile = tdfread([PATH.TEMP '/' FILENAME.DATA]);
name = char(fieldnames(outputFile));
output = getfield(outputFile, name);
% read the prototype pattern, to get some parameters of the simulation
[param, ~] = readPrototype ([PATH.TEMP '/' FILENAME.PROTOTYPE]);

end