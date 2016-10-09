clear all; clc 

modelName = 'network.txt';
procFileName = '../procs.tcl';
trainFileName = 'train.txt'; 
trainLength = 200; 
maxEpoch = 2000; 


allstages = ''; 
for epochs = trainLength: trainLength: maxEpoch
    temp_train_text = sprintf('train %d; saveWeights e%.2d.wt -text; ', trainLength, epochs/100);
    temp_test_text = sprintf('testAllActs verbalAll_e%.2d.txt VerbalRep; testAllActs hiddenAll_e%.2d.txt hidden; ', epochs/100, epochs/100);
    reload_text = sprintf('loadExamples %s; ', trainFileName);
    onestage = strcat(temp_train_text, temp_test_text, reload_text);
    allstages = strcat(allstages, onestage);
end
output = sprintf('lens -n -c %s " source %s; %s exit"', modelName, procFileName, allstages);
fprintf(output)
fprintf('\n')