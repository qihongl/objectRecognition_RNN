%% Plot MDS solution over time
% initialization
clear variables;  clc; clf;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID = 'sim23.2_noise';
% PATH.SIMID = 'sim22.2_RSVP';
% PATH.SIMID = 'sim27.1_lessUnits';
PATH.SIMID = 'sim27.5_decay';
FILENAME.ACT = 'verbal_normal_e20.txt';
% FILENAME.ACT = 'verbal_rapid_e20.txt';
% FILENAME.ACT = 'verbalAll_e2.txt';

FILENAME.PROTOTYPE = 'PROTO.xlsx';
nTimePts = 25;
PLOTALL = false;
epochNum = 0;


%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[p, proto] = readPrototype(PATH.PROTOTYPE);
data = importData(PATH, FILENAME, p, nTimePts);
% generate index matrix (itermNumber x time)
idx.full = reshape(1 : nTimePts * p.numStimuli, [nTimePts,p.numStimuli])';
chunk = nTimePts * p.numStimuli / p.numCategory.sup;

%% 
% preallocate
average.sup = zeros(nTimePts, p.numCategory.sup);
average.bas = zeros(nTimePts, p.numCategory.sup);
baseline.bas = zeros(nTimePts, p.numCategory.sup);
baseline.sup = zeros(nTimePts, p.numCategory.sup);

allSupUnitsRange = []; 
allBasUnitRange = []; 
for c = 1 : p.numCategory.sup
    allSupUnitsRange = horzcat(allSupUnitsRange,...
        (1:p.numUnits.sup) + p.numUnits.total * (c-1));
    allBasUnitRange = horzcat(allBasUnitRange, ...
        ((p.numUnits.sup+1):(p.numUnits.sup+p.numUnits.bas)) + p.numUnits.total * (c-1));
end

%% gather mean activation for each level of category 
for c = 1 : p.numCategory.sup
    % SUP activation 
    % get the c-th chuck (400 rows) of data 
    idx.diag_col = 1 + chunk * (c-1): chunk * c;
    idx.diag_row = 1 + p.numUnits.total * (c - 1) : p.numUnits.total * c;
    data_chunk = data(idx.diag_col,:); 
    % within the c-th chunk
    supUnitsRange = (1:p.numUnits.sup) + p.numUnits.total * (c-1);
    for instance = 1 : p.numInstances
        % - get the the targeted-supUnits activations 
        average.sup(:,c) = average.sup(:,c) + ...
            mean(data_chunk(idx.full(instance,:),supUnitsRange),2)/ p.numInstances;
        % - get the the non-targeted-supUnits activations 
        baseline.sup(:,c) = baseline.sup(:,c) + ... 
            mean(data_chunk(idx.full(instance,:), setdiff(allSupUnitsRange, supUnitsRange)),2)/ p.numInstances;
    end
    
    % BASIC activation 
    basicIdxVec = reshape(repmat(1:p.numCategory.bas,[p.numCategory.bas,1]),[1,p.numCategory.bas^2]);
    for instance = 1 : p.numInstances;
        basUnitsIdx = ((1 + p.numUnits.sup*basicIdxVec(instance)) : (p.numCategory.bas * (basicIdxVec(instance)+1))) + p.numUnits.total * (c-1);
        average.bas(:,c) = average.bas(:,c) + ...
            mean(data_chunk(idx.full(instance,:),basUnitsIdx), 2)/ p.numInstances;
        baseline.bas(:,c) = baseline.bas(:,c) + ...
            mean(data_chunk(idx.full(instance,:), setdiff(allBasUnitRange,basUnitsIdx)), 2)/ p.numInstances;
    end    
   
    
end


%% make plots 
clf
g.LW = 2; 
g.FS = 14; 
figure(1)
% raw activation 
subplot(121)
hold on 
plot(mean(average.sup,2), 'r', 'linewidth',g.LW)
plot(mean(average.bas,2),'b', 'linewidth',g.LW)
plot(mean(baseline.sup,2), '--r', 'linewidth',g.LW)
plot(mean(baseline.bas,2), '--b','linewidth',g.LW)
hold off 
title('Verbal Activation')
xlabel('Time ticks');ylabel('Mean Activation')
legend({'Sup-target','Basic-target','Sup-nontargets','Basic-nontarget'}, 'location', 'best')
% ylim([0 .7])
set(gca,'FontSize',g.FS)

% luce choice probability 
subplot(122)
hold on 
plot(mean(average.sup,2) ./ (mean(average.sup,2) + sum(baseline.sup,2)), 'r', 'linewidth',g.LW)
plot(mean(average.bas,2) ./ (mean(average.bas,2) + sum(baseline.bas,2)), 'b', 'linewidth',g.LW)
plot(mean(baseline.sup,2) ./ (mean(average.sup,2) + sum(baseline.sup,2)), '--r', 'linewidth',g.LW)
plot(mean(baseline.bas,2) ./ (mean(average.bas,2) + sum(baseline.bas,2)), '--b', 'linewidth',g.LW)
hold off 
xlabel('Time ticks');ylabel('Probability w.r.t alternatives')
title('Luce Probability')
legend({'Sup-target','Basic-target','Sup-nontargets','Basic-nontarget'}, 'location', 'best')
set(gca,'FontSize',g.FS)

suptitle_text = strrep(sprintf('%s', FILENAME.ACT), '_', '-');
suptitle(suptitle_text)