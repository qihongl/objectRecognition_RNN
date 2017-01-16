function [] = groupMVPA(PATH, FILENAME, propChoice, optionChoice,logParam,...
    sampleSize,timePoints,saveData,showPlot)

% loop over all option choices
for opt = 1 : length(optionChoice)
    logParam.classOpt = optionChoice{opt};
    % loop over all proportion parameters
    
    for p = 1: length(propChoice);
        logParam.subsetProp = propChoice(p);
        
        %% run the analysis
        % preallocate
        group.accuracy = nan(timePoints,sampleSize);
        group.deviation = nan(timePoints,sampleSize);
        group.response = nan(timePoints,sampleSize);
        group.hitRate = nan(timePoints,sampleSize);
        group.falseRate = nan(timePoints,sampleSize);
        for i = 1 : sampleSize
            % run classifier and compute average
            [gs, ~] = runClassifier(logParam,PATH,FILENAME,showPlot);
            
            % record the average scores in 5 matrices
            group.accuracy(:,i) = gs.averageScore.accuracy;
            group.deviation(:,i) = gs.averageScore.deviation;
            group.response(:,i) = gs.averageScore.response;
            group.hitRate(:,i) = gs.averageScore.hitRate;
            group.falseRate(:,i) = gs.averageScore.falseRate; 
            fprintf('%2.d ',i);
        end
        
        %% read metadata
        if saveData
            dataDirName = sprintf('groupScores_class/');
            subDataDirName = getSubDataDirName(PATH,FILENAME);
            finalSavePath = strcat(dataDirName,subDataDirName,'_',todayDate);
            %% save the results
            checkAndMkdir(dataDirName);
            checkAndMkdir(finalSavePath);
            dataFileName = sprintf('gsClass_%s%.3d.mat', ...
                logParam.classOpt, logParam.subsetProp * 1000);
            save([finalSavePath '/' dataFileName],'group')
        end
    end
end

end

