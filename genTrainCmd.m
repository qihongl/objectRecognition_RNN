ls
clear all; clc

trainModel = 0;

modelName = 'network.txt';
procFileName = '../procs.tcl';
trainFileName = 'train.txt';
conditions = {'normal', 'rapid'};
condition = conditions{2};
trainLength = 200;
maxEpoch = 2000;


allstages = '';
for epochs = trainLength: trainLength: maxEpoch
    if trainModel
        temp_train_text = sprintf('train %d; saveWeights e%.2d.wt -text; ', trainLength, epochs/100);
    else
        temp_train_text = sprintf('loadWeights e%.2d.wt; ', epochs/100);
    end
    temp_test_text = sprintf('testAllActs verbal_%s_e%.2d.txt VerbalRep; testAllActs hidden_%s_e%.2d.txt hidden; ', ...
        condition, epochs/100, condition, epochs/100);
    reload_text = sprintf('loadExamples %s; ', trainFileName);
    onestage = strcat(temp_train_text, temp_test_text, reload_text);
    allstages = strcat(allstages, onestage);
    fprintf(onestage)
    fprintf('\n')
end
output = sprintf('lens -n -c %s " source %s; %s exit"', modelName, procFileName, allstages);

fprintf(output)
fprintf('\n')


