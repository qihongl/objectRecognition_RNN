%% plot MDS solution over time
% [D,Z] = procrustes(X,Y(:,1:2)); % TODO: can be used to fit raw visual embedding
%% CONSTANTS
clear variables; clf; close all; clc; 
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID= 'sim16_large';
% PATH.SIMID = 'sim22.1_RSVP';
PATH.SIMID = 'sim23.2_noise';
FILENAME.ACT = 'hiddenAll_e2.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';
EPOCH = 2000;

%% read data
PATH.DATA = genDataPath(PATH, FILENAME.ACT);
data = dlmread(PATH.DATA,' ', 0,2);
data(:,size(data,2)) = []; % last column are zeros (reason unknown...)
% read prototype and parameters 
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[param, prototype] = readPrototype(PATH.PROTOTYPE);

%%
% set parameters
timePt = 25;         % select from int[1,25]
nTimePts = 25; 
nObjs = param.numStimuli;

turnOnAxis = false;
attachLabels = true;


%% compute 2 dimensional MDS
% get unique numbers in the distance matrix
tempIdx = (1 + timePt) + ((0:nObjs-1) * (nTimePts + 1));
dist.num = pdist(data(tempIdx,:));
dist.matrix = squareform(dist.num);
imagesc(dist.matrix); colormap(jet);

% compute the multidimensional scaling
[Y,evals] = cmdscale(dist.num);

%% plot it! 
% set plotting constants
SCALE = 1.3;
FS = 16;
LW = 3;

% plot 
plot(Y(:,1),Y(:,2),'bx', 'linewidth', LW);
% rescale the size of the panel
axis(max(max(abs(Y))) * [-1,1,-1,1] * SCALE); axis('square');

title_text = sprintf('Classical Metric Multidimensional Scaling [time point == %d]', timePt);
title(title_text, 'fontsize', FS)

set(gca,'FontSize',FS-1)

%% other elements in the plots

if attachLabels
    labels = nameGen(param.numCategory);
    for i = 1 : length(labels)
        labels(i) = sliceStrings(char(labels(i)));
    end
end
% attach labels and shift up the label by 5% of "max distance"
text(Y(:,1),Y(:,2)+0.05* max(max(abs(Y))),labels, ...
    'HorizontalAlignment','left', 'fontsize', FS);

if turnOnAxis
    line([-1,1],[0 0],'XLimInclude','off','Color',[.7 .7 .7])
    line([0 0],[-1,1],'YLimInclude','off','Color',[.7 .7 .7])
end