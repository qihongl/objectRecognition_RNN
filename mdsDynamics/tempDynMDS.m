%% Plot MDS solution over time
% initialization
clear variables; clf; close all; clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
PATH.SIMID = 'sim25.2_noVisNoise';
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
subsetSize = 10; 
method = 'spatialBlurring';
% method = 'randomSubset';
method = 'normal';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[param, ~] = readPrototype(PATH.PROTOTYPE);
[data, nTimePts] = importData( PATH, FILENAME, param);
nObjs = param.numStimuli;
% generate index matrix (itermNumber x time)
idx = nan(nObjs, nTimePts);
for itemNum = 1 : nObjs
    idx(itemNum,:) = (1 + (itemNum-1) * nTimePts) : (itemNum*nTimePts);
end
if all(all(idx == reshape(1:size(data,1), [nTimePts,nObjs])'))
    idx = reshape(1:size(data,1), [nTimePts,nObjs])';
else
    warning('reshape formula is not working, check why');
end

% simulate eeg-like senario: adding spatial noise or select random subset
data = eegSimulation(data, method, subsetSize, param);

%% plot sup, bas, sub cluster distances



%% compute 2 dimensional MDS
% get unique numbers in the distance matrix
dist.num = pdist(data);
% compute the multidimensional scaling
[Y, evals] = cmdscale(dist.num);

%% plot it!
% set plotting constants
graph.SCALE = 1.2;
graph.FS = 17;
graph.LW = 3;

%% static MDS - 2d
if graph.dimension == 2
    figure(1);
    % final time point MDS
    
    plot(Y(idx(:,targetTimePt),1),Y(idx(:,targetTimePt),2), 'rx', 'linewidth',graph.LW)
    mdsPlotModifier(Y, param, graph, idx);
    
    % temporal MDS
    figure(2);
    hold on
    for itemNum = 1 : nObjs
        plot(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), 'g',  'linewidth', graph.LW/2)
        plot(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), 'b.', 'linewidth', graph.LW)
    end
    % mark the initial and final locations
    plot(Y(idx(:,1),1),Y(idx(:,1),2), 'bx', 'linewidth',graph.LW)
    plot(Y(idx(:,end),1),Y(idx(:,end),2), 'rx', 'linewidth',graph.LW)
    hold off
    mdsPlotModifier(Y, param, graph, idx);
    
    %% hierach. clustering
%     figure(3);
%     tree = linkage(pdist(data(idx(:,end),:)));
%     hc = dendrogram(tree, 'Labels', nameGen(param.numCategory),...
%         'Orientation','left','ColorThreshold','default');
%     set(hc,'LineWidth',graph.LW)
    
elseif graph.dimension == 3
    %% static plot - 3d
    hold on
    for itemNum = 1 : nObjs
        % path
        plot3(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), Y(idx(itemNum,:),3), 'g',  'linewidth', graph.LW/2)
        % point
        plot3(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), Y(idx(itemNum,:),3), 'b.', 'linewidth', graph.LW)
    end    
    % mark the initial and final locations
    plot3(Y(idx(:,1),1),Y(idx(:,1),2), Y(idx(:,1),3), 'rx', 'linewidth',graph.LW)
    plot3(Y(idx(:,end),1),Y(idx(:,end),2), Y(idx(:,end),3),'rx', 'linewidth',graph.LW)
    hold off
    mdsPlotModifier(Y, param, graph, idx);
else
    error('Dimension must be 2 OR 3.')
end


%% dynamicaly create MDS solutions
if doDynamicPlot
    figure(3);
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
end
