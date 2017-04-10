%% run a group of MVPA
function [] = groupMVPA(PATH, FILENAME, propChoice, optionChoice, methodChoice, ...
    logParam, sampleSize,nTimePoints,saveData,showPlot)
logParam.nTimePoints = nTimePoints;

% loop over all methods 
for method_idx = 1 : length(methodChoice)
    logParam.method = methodChoice{method_idx};
    % loop over all option choices
    for opt = 1 : length(optionChoice)
        logParam.classOpt = optionChoice{opt};
        % loop over all proportion parameters
        for p = 1: length(propChoice); 
            logParam.subsetProp = propChoice(p);
            
            %% run classificaiton
            group = preallocate(logParam, nTimePoints, sampleSize);
            for i = 1 : sampleSize
                % run classifier and compute average
                [gs, ~] = runClassifier(logParam,PATH,FILENAME,showPlot);
                group = recordResult(group, gs, logParam, i); 
                fprintf('%2.d ',i);
            end
            fprintf('\n')
            
            %% save data 
            if saveData
                dataDirName = sprintf('groupScores_class/');
                subDataDirName = getSubDataDirName(PATH,FILENAME);
                finalSavePath = fullfile(dataDirName,subDataDirName,logParam.method);
                checkAndMkdir(dataDirName);
                checkAndMkdir(finalSavePath);
                dataFileName = sprintf('gsClass_%s%.3d.mat', ...
                    logParam.classOpt, logParam.subsetProp * 1000);
                save([finalSavePath '/' dataFileName],'group')
            end
        end
    end
end

end

% helper function: resource preallocation 
function group = preallocate(logParam, nTimePoints, sampleSize)

if logParam.collapseTime
    group.accuracy = nan(1,sampleSize);
    group.deviation = nan(1,sampleSize);
    group.hitRate = nan(1,sampleSize);
    group.falseRate = nan(1,sampleSize);
    group.beta = []; 
else
    group.accuracy = nan(nTimePoints,sampleSize);
    group.deviation = nan(nTimePoints,sampleSize);
    group.hitRate = nan(nTimePoints,sampleSize);
    group.falseRate = nan(nTimePoints,sampleSize);
end
end

% helper function: record the classification results 
function group = recordResult(group, gs, logParam, i)
if logParam.collapseTime
    group.accuracy(i) = gs.accuracy;
    group.deviation(i) = gs.deviation;
    group.hitRate(i) = gs.hitRate;
    group.falseRate(i) = gs.falseRate;
    group.beta = [group.beta gs.beta]; 
else
    group.accuracy(:,i) = gs.averageScore.accuracy;
    group.deviation(:,i) = gs.averageScore.deviation;
    group.hitRate(:,i) = gs.averageScore.hitRate;
    group.falseRate(:,i) = gs.averageScore.falseRate;
end
end