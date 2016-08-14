%% plot MDS solution over time
clear variables; clf
% [D,Z] = procrustes(X,Y(:,1:2)); % TODO: can be used to fit raw visual embedding
%% CONSTANTS
% clear variables; clf; close all; clc; 
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID= 'sim16_large';
% PATH.SIMID = 'sim22.1_RSVP';
PATH.SIMID = 'sim23.2_noise';
FILENAME.ACT = 'hiddenAll_e2.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

% set parameters
timePt = 25;         % select from int[1,25]
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
tempIdx = timePt + ((0:nObjs-1) * nTimePts);
data_t = data(tempIdx,:);
dist.num = pdist(data_t);
dist.matrix = squareform(dist.num);
imagesc(dist.matrix); colormap(jet);

% compute the multidimensional scaling
[Y,evals] = cmdscale(dist.num);

%% plot it! 
% set plotting constants
SCALE = 1.2;
FS = 20;
LW = 3;

% plot 
plot(Y(:,1),Y(:,2),'bx', 'linewidth', LW);
% rescale the size of the panel
axis(max(max(abs(Y))) * [-1,1,-1,1] * SCALE); axis('square');

title_text = sprintf('Classical Metric Multidimensional Scaling [time point == %d]', timePt);
title(title_text, 'fontsize', FS)
xlabel('Distance', 'fontsize', FS)
ylabel('Distance', 'fontsize', FS)

set(gca,'FontSize',FS)

% attach text labels
if attachLabels
    labels = nameGen(param.numCategory);
    for i = 1 : length(labels)
        labels(i) = sliceStrings(char(labels(i)));
    end
end
% attach labels and shift up the label by 5% of "max distance"
text(Y(:,1),Y(:,2)+0.05* max(max(abs(Y))),labels, ...
    'HorizontalAlignment','left', 'fontsize', FS);


%% other elements in the plots
if turnOnAxis
    line([-1,1],[0 0],'XLimInclude','off','Color',[.7 .7 .7])
    line([0 0],[-1,1],'YLimInclude','off','Color',[.7 .7 .7])
end





figure(2)
%% 
clf
% Set parameters
no_dims = 2;
initial_dims = 12;
perplexity = 10;
% Run t?SNE
mappedX = tsne(data_t, [], no_dims, initial_dims, perplexity);
% Plot results
suplab = reshape(repmat(['A'; 'B';'C'], [1,16])',[1,48]);
suplab = suplab';
gscatter(mappedX(:,1), mappedX(:,2),suplab);
hold on 
% attach labels and shift up the label by 5% of "max distance"
text(mappedX(:,1),mappedX(:,2)+0.05* max(max(abs(Y))),labels, ...
    'HorizontalAlignment','left', 'fontsize', 16);
hold off 
title('t-SNE', 'fontsize', 16)
% i = 3 
% (1 + 12*(i-1)):(12*i)
% scatter3(mappedX(:,1), mappedX(:,2),mappedX(:,3), 'r');
% scatter3(mappedX(:,1), mappedX(:,2),mappedX(:,3), 'r');


