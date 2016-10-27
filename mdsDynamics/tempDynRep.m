%% Plot MDS solution over time
% initialization
clear variables; clf;  clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID= 'sim24.2_noBias';
PATH.SIMID = 'sim23.2_noise';
% PATH.SIMID = 'sim25.2_noVisNoise';
% PATH.SIMID = 'sim28.2_sym';
PATH.SIMID = 'sim27.0_base';

FILENAME.ACT = 'verbal_normal_e20.txt';
% FILENAME.ACT = 'verbal_rapid_e20.txt';
% FILENAME.ACT = 'verbalAll_e3.txt';

FILENAME.PROTOTYPE = 'PROTO.xlsx';
nTimePts = 25;
PLOTALL = false;

% read input file name to epoch num  (DOESN WORK FOR "01", for e.g.)
% temp = strsplit(FILENAME.ACT, '_'); temp = temp(3); temp = temp{:};
% temp = strsplit(temp, '.'); temp = temp(1); temp = temp{:};
% temp(1) = [];
% temp = str2num(temp);
% epochNum = temp * 100;
epochNum = 0;


%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[param, proto] = readPrototype(PATH.PROTOTYPE);
[data, nTimePts] = importData(PATH, FILENAME, param, nTimePts);
% generate index matrix (itermNumber x time)
idx = reshape(1 : nTimePts * param.numStimuli, [nTimePts,param.numStimuli])';

%% 
dataByCat = cell(param.numCategory.sup,1);
dataRest = cell(param.numCategory.sup,1);
chunk = nTimePts * param.numStimuli / param.numCategory.sup;
for c = 1: param.numCategory.sup
    colIdx = 1+ chunk * (c-1): chunk * c;
    rowIdx = 1 + param.numUnits.total * (c - 1) : param.numUnits.total * c;
    dataByCat{c} = data(colIdx ,rowIdx);
    dataRest{c} = data(colIdx ,rowIdx);
end

% subplot(121);imagesc(dataByCat{1}(7:25:400,:));subplot(122);imagesc(proto)

%% compute the average
% preallocate
average.sup = zeros(nTimePts, param.numCategory.sup);
average.bas = zeros(nTimePts, param.numCategory.sup);
baseline.bas = zeros(nTimePts, param.numCategory.sup);
baseline.sup = zeros(nTimePts, param.numCategory.sup);


for c = 1:param.numCategory.sup;
    % get activation values at corresponding units: superordinate
    supUnitsRange = 1:param.numUnits.sup;
    for instance = 1 : param.numInstances
        average.sup(:,c) = average.sup(:,c) + ...
            mean(dataByCat{c}(idx(instance,:),supUnitsRange),2)/ param.numInstances;
    end
    
    
    
    % get activation values at corresponding units: basic
    basUnitRange = (param.numUnits.sup+1):(param.numUnits.sup+param.numUnits.bas);
    basicIdxVec = reshape(repmat(1:param.numCategory.bas,[param.numCategory.bas,1]),[1,param.numCategory.bas^2]);
    
    for instance = 1 : param.numInstances;
        basUnitsIdx = (1 + param.numUnits.sup*basicIdxVec(instance)) : (param.numCategory.bas * (basicIdxVec(instance)+1));
        average.bas(:,c) = average.bas(:,c) + mean(dataByCat{c}(idx(instance,:),basUnitsIdx), 2);
        baseline.bas(:,c) = baseline.bas(:,c) + mean(dataByCat{c}(idx(instance,:), setdiff(basUnitRange,basUnitsIdx)), 2);
    end
    average.bas(:,c) = average.bas(:,c) / param.numInstances;
    baseline.bas(:,c) = baseline.bas(:,c) / param.numInstances;
    
    

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

% average across instance and super-category
average.sup = mean(average.sup,2);
% average.bas = mean(average.bas / param.numInstances,2);
average.bas = mean(average.bas,2);
average.baseline.bas = mean(baseline.bas,2);

% subplot(121);imagesc(proto(:,(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total))
% subplot(122);imagesc(dataByCat{c}(7:nTimePts:size(dataByCat{1},1),(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total))
% temp1 = proto(:,(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total);
% temp2 = dataByCat{c}(7:nTimePts:size(dataByCat{1},1),(param.numUnits.sup + param.numUnits.bas+1) : param.numUnits.total);
% temp1 = logical(temp1)
% temp2(temp1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotVerbalTemporalResponse(average, epochNum, PLOTALL)
% figure()
% plot(average.bas ./ (average.bas + average.baseline.bas))