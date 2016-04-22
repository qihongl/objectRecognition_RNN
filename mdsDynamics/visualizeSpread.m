%% Plot the spread over time
% initialization
clear variables; clf; clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
PATH.SIMID = 'sim23.2_noise';
% PATH.SIMID = 'sim25.2_RSVP';
FILENAME.ACT = 'hiddenAll_e2.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

% set parameters
targetTimePt = 25;       % select from int[1,25]
graph.turnOnAxis = false;
graph.attachLabels = 1;
doDynamicPlot = 0;
graph.dimension = 2;
% stimulate properties of EEG
subsetSize = 3;
method = 'spatialBlurring';
% method = 'randomSubset';
% method = 'normal';
simSize = 1000;

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
[data, nTimePts] = importData( PATH, FILENAME, param);
nObjs = param.numStimuli;
% generate index matrix (itermNumber x time)
idx = reshape(1:size(data,1), [nTimePts,nObjs])';

%% plot cluster spreads with in sup vs. bas categories
% preallocate 
meanSpread_byPath = cell(simSize,1);
meanSpread_byPDist = cell(simSize,1);
dataSp = cell(simSize,1);
supMeanSpread.within = zeros(nTimePts,param.numUnits.total*param.numCategory.sup);
basMeanSpread.within = zeros(size(supMeanSpread.within));

spRatio_byPDist = zeros(nTimePts,1);
% do the simulation n times
for i = 1 : simSize
    dataSp{i} = eegSimulation(data, method, subsetSize, param);
    % 
    meanSpread_byPath{i} = getSpread_byPath(dataSp{i}, param, idx, nTimePts);
    supMeanSpread.within = meanSpread_byPath{i}.sup.within;
    basMeanSpread.within = meanSpread_byPath{i}.bas.within;
    supMeanSpread.bet = meanSpread_byPath{i}.sup.bet;
    basMeanSpread.bet = meanSpread_byPath{i}.bas.bet;
    % 
    meanSpread_byPDist = getSpread_byPDist(dataSp{i}, param, idx, nTimePts);
    spRatio_byPDist = spRatio_byPDist + meanSpread_byPDist.between  ./ meanSpread_byPDist.within;
end
% get average spread
supMeanSpread.within = supMeanSpread.within/simSize;
basMeanSpread.within = basMeanSpread.within/simSize;
supMeanSpread.bet = supMeanSpread.bet/simSize;
basMeanSpread.bet = basMeanSpread.bet/simSize;
% 
spRatio_byPDist = spRatio_byPDist / simSize;


%% plot the spread: sup category
subplot(2,2,1)
hold on
plot(mean(supMeanSpread.within,2), 'linewidth',graph.LW)
plot(mean(basMeanSpread.within,2), 'linewidth',graph.LW)
hold off

legend({'superordinate','basic'}, 'fontsize', graph.FS, 'location', 'southeast')
if strcmp(method,'normal')
    title_spread = sprintf('The spread within (method: %s, size: NA)', method);
else
    title_spread = sprintf('The spread within (method: %s, size: %d)', method, subsetSize);
end
title(title_spread, 'fontsize', graph.FS)
xlabel('Time', 'fontsize', graph.FS)
ylabel('Sum of the spread', 'fontsize', graph.FS)
set(gca,'FontSize',graph.FS)

% plot the spread: basic category 
subplot(2,2,2)
hold on
plot(mean(supMeanSpread.bet,2), 'linewidth',graph.LW)
plot(mean(basMeanSpread.bet,2), 'linewidth',graph.LW)
hold off

legend({'superordinate','basic'}, 'fontsize', graph.FS, 'location', 'southeast')
if strcmp(method,'normal')
    title_spread = sprintf('The spread between (method: %s, size: NA)', method);
else
    title_spread = sprintf('The spread between (method: %s, size: %d)', method, subsetSize);
end
title(title_spread, 'fontsize', graph.FS)
xlabel('Time', 'fontsize', graph.FS)
ylabel('Sum of the spread', 'fontsize', graph.FS)
set(gca,'FontSize',graph.FS)


% plot the between - within spread ratio ~= decodibility 
subplot(2,2,3)
betweenWithinRatio = mean(supMeanSpread.bet ./ supMeanSpread.within,2);
plot(betweenWithinRatio, 'linewidth', graph.LW)

title('Spread ratio by path: Bet/Within ', 'fontsize', graph.FS)
xlabel('Time', 'fontsize', graph.FS)
ylabel('Decodibility', 'fontsize', graph.FS)
set(gca,'FontSize',graph.FS)


subplot(2,2,4)
plot(spRatio_byPDist, 'linewidth', graph.LW);
title('Spread ratio by dist: Bet/Within ', 'fontsize', graph.FS)
xlabel('Time', 'fontsize', graph.FS)
ylabel('Decodibility', 'fontsize', graph.FS)
set(gca,'FontSize',graph.FS)
