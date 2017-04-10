%% visualize informativeness over time
clear; clc;
%% load file and compute summarized data
mainDirName = 'groupScores_class';
condition = 'randomSubset';
% condition = 'spatBlurring';
method = 'lasso';
%
simNum = 27;
presentation = 'normal';
% simName = 'decay';
simName = 'varyNoise';
ep = 20;
simNum_sub = 1;
rep_idx = 0;

% gather data
data_sub = cell(length(simNum_sub),1);
for i = 1 : length(rep_idx)
    % get path name
    subDirName = sprintf('sim%d.%d_%s_%s_e%d_%.2d', ...
        simNum,simNum_sub,simName,presentation,ep, rep_idx(i));
    pathName = fullfile(mainDirName,subDirName,method);
    listing = dir([pathName '/gsClass_' condition '*.mat']);
    
    % summarize the data
    propUsed = cell(size(listing,1),1);
    betas = cell(size(listing,1),1);
    for j = 1 : size(listing,1)
        % load a data file
        fileName = listing(j).name;
        load([pathName '/' fileName])
        % build legend
        propUsed{j} = extractPropUsed(fileName, condition)/10;
        % compute means
        betas{j} = group.beta;
    end
    
end


%% plot feature informativeness over time 
nTps = 25;
for i = 1 : length(betas)
    subplot(1, length(betas), i)
    mean_sims = mean(abs(betas{i}),2);
    mean_voxels = mean(reshape(mean_sims, nTps, size(betas{i},1)/ nTps), 2);
    plot(mean_voxels)
end

