%% Plot the spread over time
% initialization
clear variables; clf; clc;
PATH.PROJECT = '..';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID = 'sim22.2_RSVP';
% PATH.SIMID = 'sim23.2_noise';
PATH.SIMID = 'sim27.5_varyNoise';
FILENAME.ACT = 'hidden_normal_e20.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';
PATH.rep_idx = 4; 

% stimulate properties of EEG
subsetSize = 2;
method = 'spatialBlurring';
% method = 'randomSubset';
% method = 'normal';
simSize = 100;
nTimePts = 25; 

% set plotting constants
graph.SCALE = 1.2;
graph.FS = 17;
graph.LW = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start
sprintf('Method: %s.\n', method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[param, ~] = readPrototype(PATH.PROTOTYPE);
[data] = importData( PATH, FILENAME, param, nTimePts);
nObjs = param.numStimuli;
% generate index matrix (itermNumber x time)
idx = reshape(1:size(data,1), [nTimePts,nObjs])';

%% compute "cluster spreads": sup(between vs. within) & basic 
% preallocate 
meanSpread_byPath = cell(simSize,1);
meanSpread_byPDist = cell(simSize,1);
dataSp = cell(simSize,1);

supMeanSpread.within.sample = nan(nTimePts,simSize);
supMeanSpread.bet.sample = nan(size(supMeanSpread.within.sample));
basMeanSpread.within.sample = zeros(size(supMeanSpread.within.sample));
basMeanSpread.bet.sample = nan(size(supMeanSpread.within.sample));

spRatio_byPDist.sample = nan(nTimePts,simSize);
% do the simulation n times
for i = 1 : simSize
    dataSp{i} = eegSimulation(data, method, subsetSize, param);
    % evaluate the spread by standard deviation of the path
    meanSpread_byPath{i} = getSpread_byPath(dataSp{i}, param, idx, nTimePts);
    supMeanSpread.within.sample(:,i) = meanSpread_byPath{i}.sup.within;
    basMeanSpread.within.sample(:,i) = meanSpread_byPath{i}.bas.within;
    supMeanSpread.bet.sample(:,i) = meanSpread_byPath{i}.sup.bet;
    basMeanSpread.bet.sample(:,i) = meanSpread_byPath{i}.bas.bet;

    % evaluate the spread by the average of all pair-wise distances
    meanSpread_byPDist = getSpread_byPDist(dataSp{i}, param, idx, nTimePts);
    spRatio_byPDist.sample(:,i) = meanSpread_byPDist.between  ./ meanSpread_byPDist.within;
    
end
% get average spread
supMeanSpread.within.mean = mean(supMeanSpread.within.sample,2);
supMeanSpread.within.std = std(supMeanSpread.within.sample,1,2);
supMeanSpread.bet.mean = mean(supMeanSpread.bet.sample,2);
supMeanSpread.bet.std = std(supMeanSpread.bet.sample,1,2);
basMeanSpread.within.mean = mean(basMeanSpread.within.sample,2); 
basMeanSpread.within.std = std(basMeanSpread.within.sample,1,2); 
basMeanSpread.bet.mean = mean(basMeanSpread.bet.sample,2);
basMeanSpread.bet.std = std(basMeanSpread.bet.sample,1,2);

% spreading ratio using std measure 
spRatio_byPath.mean = supMeanSpread.bet.mean ./ supMeanSpread.within.mean; 
spRatio_byPath.std = std(supMeanSpread.bet.sample ./ supMeanSpread.within.sample,1,2);

% spreading ratio using pair-wise distances measure
spRatio_byPDist.mean = mean(spRatio_byPDist.sample,2);
spRatio_byPDist.std = std(spRatio_byPDist.sample,1,2);

%% plot the spread: sup category

alpha = .975; 
tval = tinv(alpha, simSize - 1);

% subplot(1,2,1)
% hold on
% plot(supMeanSpread.within.mean, 'linewidth',graph.LW)
% plot(basMeanSpread.within.mean, 'linewidth',graph.LW)
% hold off
% 
% legend({'superordinate','basic'}, 'fontsize', graph.FS, 'location', 'southeast')
% title('The spread within', 'fontsize', graph.FS)
% xlabel('Time', 'fontsize', graph.FS)
% ylabel('Sum of the spread', 'fontsize', graph.FS)
% set(gca,'FontSize',graph.FS)
% 
% % plot the spread: basic category 
% subplot(1,2,2)
% hold on
% plot(supMeanSpread.bet.mean, 'linewidth',graph.LW)
% plot(basMeanSpread.bet.mean, 'linewidth',graph.LW)
% hold off
% legend({'superordinate','basic'}, 'fontsize', graph.FS, 'location', 'southeast')
% title('The spread between', 'fontsize', graph.FS)
% xlabel('Time', 'fontsize', graph.FS)
% ylabel('Sum of the spread', 'fontsize', graph.FS)
% set(gca,'FontSize',graph.FS)


% plot the between - within spread ratio ~= decodibility 
subplot(1,2,1)
hold on 
plot(spRatio_byPath.mean, 'linewidth', graph.LW)
errorbar(1:nTimePts, spRatio_byPath.mean, tval * spRatio_byPath.std / sqrt(simSize), ...
    'b','linewidth', graph.LW/2);
hold off
xlim([1,nTimePts+1])

title('Spread ratio by path: Bet/Within ', 'fontsize', graph.FS)
xlabel('Time', 'fontsize', graph.FS)
ylabel('Decodibility', 'fontsize', graph.FS)
set(gca,'FontSize',graph.FS)

% plot the between - within spread ratio | with pair-wise dist measure
subplot(1,2,2)
hold on 
plot(spRatio_byPDist.mean, 'linewidth', graph.LW);
errorbar(1:nTimePts, spRatio_byPDist.mean, tval * spRatio_byPDist.std / sqrt(simSize),...
    'b','linewidth', graph.LW/2);
hold off
xlim([1,nTimePts+1])
title('Spread ratio by p-dist: Bet/Within', 'fontsize', graph.FS)
xlabel('Time', 'fontsize', graph.FS)
ylabel('Decodibility', 'fontsize', graph.FS)
set(gca,'FontSize',graph.FS)

%% over all title
makeSupTitle(method,subsetSize, simSize)
sprintf('Done')