%% Plot MDS solution over time
% initialization
clear variables; clf; close all; clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID= 'sim16_large';
% PATH.SIMID = 'sim22.1_RSVP';
PATH.SIMID = 'sim23.2_noise';
FILENAME.ACT = 'hiddenAll_e2.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

% set parameters
timePt = 1;         % select from int[1,25]
turnOnAxis = false;
attachLabels = true;

%% read data
% fixed parameters
nTimePts = 25;    % you probably don't want to change it..
% read prototype and parameters
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[param, prototype] = readPrototype(PATH.PROTOTYPE);
nObjs = param.numStimuli;

% read data
PATH.DATA = genDataPath(PATH, FILENAME.ACT);
data = dlmread(PATH.DATA,' ', 0,2);
data(:,size(data,2)) = []; % last column are zeros (reason unknown...)
data(1 + (0:nObjs-1)*(nTimePts+1),:) = []; % remove zero rows

%% compute 2 dimensional MDS
% get unique numbers in the distance matrix
dist.num = pdist(data);
% compute the multidimensional scaling
[Y,evals] = cmdscale(dist.num);
Y = Y(:,1:2);

%% plot it!
% set plotting constants
SCALE = 1.2;
FS = 16;
LW = 3;

hold on
for itemNum = 1 : nObjs
    tempIdx = (1 + (itemNum-1) * nTimePts) : (itemNum*nTimePts);
    plot(Y(tempIdx,1),Y(tempIdx,2), 'b')
    plot(Y(tempIdx,1),Y(tempIdx,2), 'b.')
end

initIdx = 1 + (0:nObjs-1) * nTimePts;
plot(Y(initIdx,1),Y(initIdx,2), 'rx', 'linewidth',3)
hold off

% square form plot 
axis(max(max(abs(Y))) * [-1,1,-1,1] * SCALE); axis('square');

% add title
title_text = 'Classical Metric Multidimensional Scaling over time';
title(title_text, 'fontsize', FS)
set(gca,'FontSize',FS-1)


if attachLabels
    labels = nameGen(param.numCategory);
    for i = 1 : length(labels)
        tempSlices = strsplit(labels{i},'_');
        labels{i} = tempSlices(1);
    end
    
    finalIdx = nTimePts + (0:nObjs-1) * nTimePts;
    text(Y(finalIdx,1),Y(finalIdx,2)+0.05* max(max(abs(Y))),labels, ...
        'HorizontalAlignment','left', 'fontsize', FS);
end

if turnOnAxis
    line([-1,1],[0 0],'XLimInclude','off','Color',[.7 .7 .7])
    line([0 0],[-1,1],'YLimInclude','off','Color',[.7 .7 .7])
end