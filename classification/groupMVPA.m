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
            result_dc = cell(sampleSize,1); 
            for i = 1 : sampleSize
                % run classifier and compute average
                [gs_cur, gs_dc, ~] = runClassifier(logParam,PATH,FILENAME,showPlot);
                group = recordResult(group, gs_cur, logParam, i);
                if logParam.dynamicCode
                    result_dc{i} = summarize_dc_across_sup_cat(gs_dc);
                end
                fprintf('%2.d ',i);
            end
            result_dc = summarize_dc_across_sample(result_dc);
            fprintf('\n')
            
            %% save data
            if saveData
                % construct save path and dir 
                dataDirName = sprintf('groupScores_class/');
                subDataDirName = getSubDataDirName(PATH,FILENAME);
                finalSavePath = fullfile(dataDirName,subDataDirName,logParam.method);
                checkAndMkdir(dataDirName);
                checkAndMkdir(finalSavePath);
                % save data 
                data_gp_fileName = sprintf('gs_%s%.3d.mat', ...
                    logParam.classOpt, logParam.subsetProp * 1000);
                save([finalSavePath '/' data_gp_fileName],'result_dc')
                data_dc_filename = sprintf('dc_%s%.3d.mat', ...
                    logParam.classOpt, logParam.subsetProp * 1000);
                save([finalSavePath '/' data_dc_filename],'result_dc')
            end
        end
    end
end

end

%% helper functions 

% resource preallocation
function group = preallocate(param, nTimePoints, sampleSize)
if param.collapseTime
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

% record the classification results
function r = recordResult(r, result, logParam, i)
if logParam.collapseTime
    r.accuracy(i) = result.accuracy;
    r.deviation(i) = result.deviation;
    r.hitRate(i) = result.hitRate;
    r.falseRate(i) = result.falseRate;
    r.beta = [r.beta result.beta];
else
    r.accuracy(:,i) = result.averageScore.accuracy;
    r.deviation(:,i) = result.averageScore.deviation;
    r.hitRate(:,i) = result.averageScore.hitRate;
    r.falseRate(:,i) = result.averageScore.falseRate;
end
end

% for dynamic code: summarize data across sup cats 
function r = summarize_dc_across_sup_cat(result)
[nTps,nCats] = size(result);
r = cell(nTps, 1);
for t = 1 : nTps
    % compute the average decoding trajectory across sup cats
    temp.acc = zeros(nTps, 1);
    temp.dev = zeros(nTps, 1);
    temp.hr = zeros(nTps, 1);
    temp.fr = zeros(nTps, 1);
    for c = 1 : nCats
        temp.acc = temp.acc + result{t,c}.accuracy;
        temp.dev = temp.dev + result{t,c}.deviation;
        temp.hr = temp.hr + result{t,c}.hitRate;
        temp.fr = temp.fr + result{t,c}.falseRate;
    end
    temp.acc = temp.acc /nCats;
    temp.dev = temp.dev /nCats;
    temp.hr  = temp.hr /nCats;
    temp.fr  = temp.fr /nCats;
    % collect the result
    r{t} = temp;
end
end

% for dynamic code: summarize data across the simulation sample 
function r = summarize_dc_across_sample(result)
% get params
n = length(result);
nTps = length(result{1});
r = cell(nTps,1); 
% for each time point
for t = 1 : nTps
    % average data across sample 
    temp.acc = zeros(nTps,1);
    temp.dev = zeros(nTps,1);
    temp.hr =  zeros(nTps,1);
    temp.fr =  zeros(nTps,1);
    for i = 1 : n
        temp.acc = temp.acc + result{i}{t}.acc;
        temp.dev = temp.dev + result{i}{t}.dev;
        temp.hr =  temp.hr + result{i}{t}.hr;
        temp.fr =  temp.fr + result{i}{t}.fr;
    end
    temp.acc = temp.acc /n;
    temp.dev = temp.dev /n;
    temp.hr =  temp.hr /n;
    temp.fr =  temp.fr /n; 
    % save the mean result 
    r{t} = temp; 
end
end