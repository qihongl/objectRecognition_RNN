%% Plot MDS solution over time
% initialization
clear variables; clf; close all; clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID= 'sim16_large';
% PATH.SIMID = 'sim22.2_RSVP';
PATH.SIMID = 'sim23.2_noise';
FILENAME.ACT = 'hiddenAll_e4.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

% set parameters
timePt = 1;         % select from int[1,25]
graph.turnOnAxis = false;
graph.attachLabels = false;

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
graph.SCALE = 1.2;
graph.FS = 16;
graph.LW = 3;

%% static plot
subplot(1,2,1)
hold on
for itemNum = 1 : nObjs
    tempIdx = (1 + (itemNum-1) * nTimePts) : (itemNum*nTimePts);
    plot(Y(tempIdx,1),Y(tempIdx,2), 'g',  'linewidth', graph.LW/2)
    plot(Y(tempIdx,1),Y(tempIdx,2), 'b.', 'linewidth', graph.LW)
end
% mark the initial and final locations
idx.init = 1 + (0:nObjs-1) * nTimePts;
idx.final = nTimePts + (0:nObjs-1) * nTimePts;
plot(Y(idx.init,1),Y(idx.init,2), 'rx', 'linewidth',graph.LW)
plot(Y(idx.final,1),Y(idx.final,2), 'rx', 'linewidth',graph.LW)
hold off

mdsPlotModifier(Y, param, graph, idx);


%% dynamics plot
subplot(1,2,2)


for n = 1 : nObjs
    h{n} = animatedline;
end
% setup plotting panel
axis(max(max(abs(Y))) * [-1,1,-1,1] * graph.SCALE); axis('square');

% y values at time t
for t = 1:nTimePts
    for n = 1 : nObjs
        % create index the t-th location for n-th object
        th.idx = t + nTimePts * (n-1);
        % add the point
        addpoints(h{n},Y(th.idx,1),Y(th.idx,2)); drawnow;
    end    
end
mdsPlotModifier(Y, param, graph, idx);
