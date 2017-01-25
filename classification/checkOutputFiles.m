% check the dimension of output files, in the form of %layer_%condition_e%d
clear variables; clf; close all;
PATH.PROJECT = '../';
FILENAME.DATA = 'hidden_normal_e20.txt';

%% Specify the Path information (user needs to do this!)
PATH.PROJECT = '../';
FILENAME.PROTOTYPE = 'PROTO.xlsx';
epMax = 20; 
epMin = 2; 
epInterval = 2; 

% provide the NAMEs of the data files (user need to set them mannually)
simName = 'decay';
sim_idx = 27;
rep_idxs = 2 : 17

for rep_idx = rep_idxs
    PATH.DATA_FOLDER = sprintf('sim%d.%d_%s', sim_idx, rep_idx, simName);
    fprintf('%s: \t', PATH.DATA_FOLDER)
    for ep = epMin : epInterval : epMax
        FILENAME.DATA = sprintf('hidden_normal_e%.2d.txt', ep);
        
        [output, param] = loadData(PATH, FILENAME);
        fprintf('[%d, %d] ', size(output,1), size(output,2))
    end
    fprintf('\n')
end