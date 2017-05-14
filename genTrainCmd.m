ls
clear all; clc

trainModel = 1;
subFolderName = '03';

modelName = 'network.txt';
procFileName = '../procs.tcl';
trainFileName = 'train.txt';
conditions = {'normal', 'rapid'};
condition = conditions{1};
trainLength = 200;
maxEpoch = 2000;

allstages = '';
for epochs = trainLength: trainLength: maxEpoch
    if trainModel
        temp_train_text = sprintf('train %d; saveWeights %s/e%.2d.wt -text; ', trainLength, subFolderName, epochs/100);
    else
        temp_train_text = sprintf('loadWeights %s/e%.2d.wt; ', subFolderName,epochs/100);
    end
    temp_test_text = sprintf('testAllActs %s/verbal_%s_e%.2d.txt VerbalRep; testAllActs %s/hidden_%s_e%.2d.txt hidden; ', ...
        subFolderName, condition, epochs/100, subFolderName, condition, epochs/100);
    reload_text = sprintf('loadExamples %s; ', trainFileName);
    onestage = strcat(temp_train_text, temp_test_text, reload_text);
    allstages = strcat(allstages, onestage);
    fprintf(onestage)
    fprintf('\n')
end
output = sprintf('lens -n -c %s " source %s; %s exit"', modelName, procFileName, allstages);
fprintf('\n')
fprintf(output)
fprintf('\n')
