%% Plot MDS solution over time
% initialization
clear variables; clf; close all; clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID= 'sim24.2_noBias';
PATH.SIMID = 'sim25.2_noVisNoise';
FILENAME.ACT = 'hiddenAll_e6.txt';
FILENAME.ACT = 'verbalAll_e6.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[param, proto] = readPrototype(PATH.PROTOTYPE);
[data, nTimePts] = importData( PATH, FILENAME, param);
nObjs = param.numStimuli;
% generate index matrix (itermNumber x time)
idx = nan(nObjs, nTimePts);
for itemNum = 1 : nObjs
    idx(itemNum,:) = (1 + (itemNum-1) * nTimePts) : (itemNum*nTimePts);
end

%%
dataByCat = cell(param.numCategory.sup,1);
chunk = nTimePts * param.numStimuli / param.numCategory.sup;
for c = 1: param.numCategory.sup
    colIdx = 1+ chunk * (c-1): chunk * c;
    rowIdx = 1 + param.numUnits.total * (c - 1) : param.numUnits.total * c;
    dataByCat{c} = data(colIdx ,rowIdx);
end


% imagesc(data(colIdx ,rowIdx))

%% 
for c = 1:param.numCategory.sup;
    % preallocate 
    average.sup = zeros(nTimePts,1);
    average.bas = zeros(nTimePts,1);
    % get activation values at corresponding units: superordinate 
    supUnitsRange = 1:param.numUnits.sup;
    for instance = 1 : param.numStimuli/param.numCategory.sup;
        average.sup = average.sup + mean(dataByCat{c}(idx(instance,:),supUnitsRange),2);
    end
    % get activation values at corresponding units: basic
    basUnitRange = (param.numUnits.sup+1):(param.numUnits.sup+param.numUnits.bas);
    basicIdxVec = reshape(repmat(1:param.numCategory.bas,[param.numCategory.bas,1]),[1,param.numCategory.bas^2]);    
    for instance = 1 : param.numStimuli/param.numCategory.sup;
        basUnitsIdx = (1+param.numUnits.sup*basicIdxVec(instance)) : (param.numCategory.bas * (basicIdxVec(instance)+1));
        average.bas = average.bas + mean(dataByCat{c}(idx(instance,:),basUnitsIdx), 2);
    end
    % get activation values at corresponding units: sub
end

average.sup = average.sup / nTimePts;
average.bas = average.bas / nTimePts;

% plot the data
p.LW = 4; 
p.FS = 18; 

% subplot(1,2,1)
hold on
% plot three temporal activation pattern
plot(average.sup,'g', 'linewidth', p.LW)
plot(average.bas,'r', 'linewidth', p.LW)
% plot(mSub, 'linewidth', p.LW)
hold off 

% xlim([0 26]);
% ylim([0 .7]);
set(gca,'FontSize',p.FS)
legend({'Superordinate', 'Basic', 'Subordinate'}, 'location', 'southeast', 'fontsize', p.FS)
% TITLE = sprintf('Temporal dynamics of verbal responses');
% title(TITLE, 'fontSize', 18);
xlabel('Time Ticks', 'fontSize', p.FS)
ylabel('Activation Value', 'fontSize', p.FS)
