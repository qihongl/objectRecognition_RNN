%% Plot MDS solution over time
% initialization
clear variables;  clc; clf;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
PATH.SIMID = 'sim27.0_base';
FILENAME.PROTOTYPE = 'PROTO.xlsx';
PATH.OUTPUT = fullfile(PATH.PROJECT, PATH.SIMID, 'csv');
nTimePts = 25;
simName = 'verbal_normal';
epochNum = 2 : 4 : 20;


fprintf('Output files to: %s\n', PATH.OUTPUT)
for e = 1 : length(epochNum)
    FILENAME.ACT = sprintf('%s_e%.2d.txt', simName,epochNum(e));
    % read data
    PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
    [p, proto] = readPrototype(PATH.PROTOTYPE);
    data = importData(PATH, FILENAME, p, nTimePts);
    
    % write to csv
    temp = strsplit(FILENAME.ACT, '.');
    output_filename = strcat(temp{1},'.csv');
    csvwrite(fullfile(PATH.OUTPUT,output_filename),data)
    
    fprintf('\tConvert <%s> to <%s>\n', FILENAME.ACT, output_filename)
end
