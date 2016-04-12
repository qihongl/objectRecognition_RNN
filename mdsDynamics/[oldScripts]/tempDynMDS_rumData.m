%% plot MDS solution over time
% [D,Z] = procrustes(X,Y(:,1:2)); % TODO: can be used to fit raw visual embedding
clear all; clc; close all; 
% get parameters
timePt = 20;
turnOnAxis = false;
attachLabels = true;

%% read the data
fname = 'dev.acts';
data = dlmread(fname,' ', 0,3);
data(:,size(data,2)) = [];
% fixed parameters
nObjs = 8;
nQs = 32;


%% compute 2 dimensional MDS
dist.num = pdist(data);
[Y,evals] = cmdscale(dist.num);
Y = Y(:,1:2);

%% plot it!
% set plotting constants
SCALE = 1.3;
FS = 14;
LW = 3;

hold on
for itemNum = 1 : nObjs
    idx = (0:29) * nQs + itemNum;
    plot(Y(idx,1),Y(idx,2), 'b')
    plot(Y(idx,1),Y(idx,2), 'bo')
end
plot(Y(1:nObjs,1),Y(1:nObjs,2), 'rx', 'linewidth',3)
hold off

labels = getLabels_1toN(fname,nObjs);
for i = 1 : length(labels)
    tempSlices = strsplit(labels{i},'_');
    labels{i} = tempSlices(1);
end
text(Y(29 * nQs + (1:8),1),Y(29 * nQs + (1:8),2)+0.05* max(max(abs(Y))),labels, ...
    'HorizontalAlignment','left', 'fontsize', FS);

%
% % plot
% plot(Y(:,1),Y(:,2),'bx', 'linewidth', LW);
% % rescale the size of the panel
% axis(max(max(abs(Y))) * [-1,1,-1,1] * SCALE); axis('square');
% title_text = sprintf('Classical metric MDS at time point %d', timePt);
% title(title_text, 'fontsize', FS)
%
% %% other elements in the plots
% if attachLabels
%     for i = 1 : length(labels)
%         labels(i) = sliceStrings(char(labels(i)));
%     end
% end
% % attach labels and shift up the label by 5% of "max distance"
% text(Y(:,1),Y(:,2)+0.05* max(max(abs(Y))),labels, ...
%     'HorizontalAlignment','left', 'fontsize', FS);
%
% if turnOnAxis
%     line([-1,1],[0 0],'XLimInclude','off','Color',[.7 .7 .7])
%     line([0 0],[-1,1],'YLimInclude','off','Color',[.7 .7 .7])
% end