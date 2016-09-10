%% Plot MDS solution over time
% initialization
clear variables; clf;  clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID= 'sim24.2_noBias';
% PATH.SIMID = 'sim23.2_noise';
PATH.SIMID = 'sim25.2_noVisNoise';

% PATH.SIMID = 'sim22.2_RSVP';
FILENAME.ACT = 'verbalAll_e2.txt';
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


% subplot(121);imagesc(dataByCat{1}(7:25:400,:));subplot(122);imagesc(proto)

%% compute the average 
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
%     % get activation values at corresponding units: sub
%     subIdx = (param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total;
%     act.sub = nan(nTimePts,length(subIdx));
%     % gather sub act over time 
%     for t = 1 : nTimePts
%         actualReponse = dataByCat{c}(t:nTimePts:size(dataByCat{1},1),subIdx);
%         protoPos = proto(:,(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total);
%         protoPos = logical(protoPos);
%         actualReponse(protoPos);
%         
%     end
    
end

average.sup = average.sup / nTimePts;
average.bas = average.bas / nTimePts;

% subplot(121);imagesc(proto(:,(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total))
% subplot(122);imagesc(dataByCat{c}(7:nTimePts:size(dataByCat{1},1),(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total))
% temp1 = proto(:,(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total);
% temp2 = dataByCat{c}(7:nTimePts:size(dataByCat{1},1),(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total);
% temp1 = logical(temp1)
% temp2(temp1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p.LW = 4; 
p.FS = 20; 
%% 
subplot(2,2,1)
hold on
% plot three temporal activation pattern
plot(average.sup,'g', 'linewidth', p.LW)
plot(average.bas,'r', 'linewidth', p.LW)
% plot(mSub, 'linewidth', p.LW)
hold off 

xlim([0 25]);
ylim([0 .5]);
legend({'Superordinate', 'Basic'}, 'location', 'southeast', 'fontsize', p.FS, 'FontWeight','bold')
title_text = sprintf('Verbal responses');
title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
ylabel('Activation Value of Verbal Rep.', 'fontSize', p.FS, 'FontWeight','bold')
set(gca,'FontSize',p.FS)

%% 
subplot(2,2,2)

prob.bas = average.bas ./ (average.sup + average.bas);
prob.sup = average.sup ./ (average.sup + average.bas);
hold on 
plot(prob.sup,'g', 'linewidth', p.LW)
plot(prob.bas,'r', 'linewidth', p.LW)
hold off

% legend({'Superordinate', 'Basic'}, 'location', 'southeast', 'fontsize', p.FS, 'FontWeight','bold')
title_text = sprintf('Luce Choice Probability');
title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
ylabel('Relative Probability', 'fontSize', p.FS, 'FontWeight','bold')
set(gca,'FontSize',p.FS)

%% 
subplot(2,2,3)

% crossOverPt = find(min(abs(prob.bas - prob.sup)) == abs(prob.bas - prob.sup));

% arbitarily chosen time points
timeSections = [5 7 25];
timeSecData = horzcat(prob.sup(timeSections),prob.bas(timeSections));

mybar = bar(timeSecData);
set(gca,'xticklabel',{'5','7','25'})

mybar(1).FaceColor = 'g';
mybar(2).FaceColor = 'r';

title_text = sprintf('Time sections');
title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
ylabel('Relative Probability', 'fontSize', p.FS, 'FontWeight','bold')
set(gca,'FontSize',p.FS)

%% 
subplot(2,2,4)
% mybar = bar(timeSecData);

% set(gca,'xticklabel',{'t1','t2','t3'})
% mybar(1).FaceColor = 'g';
% mybar(2).FaceColor = 'r';

title_text = sprintf('Empirical data');
title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
ylabel('--', 'fontSize', p.FS, 'FontWeight','bold')
set(gca,'FontSize',p.FS)




