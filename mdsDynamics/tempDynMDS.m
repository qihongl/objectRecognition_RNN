%% Plot MDS solution over time
% initialization
clear variables; clf; close all; clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID= 'sim16_large';
PATH.SIMID = 'sim23.3_noise';
% PATH.SIMID = 'sim22.1_RSVP';
FILENAME.ACT = 'hiddenAll_e4.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

% set parameters
targetTimePt = 25;       % select from int[1,25]
graph.turnOnAxis = false;
graph.attachLabels = false;
doDynamicPlot = false;
dimension = 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[param, ~] = readPrototype(PATH.PROTOTYPE);
[data, nTimePts] = importData( PATH, FILENAME, param);
nObjs = param.numStimuli;

%% compute 2 dimensional MDS
% get unique numbers in the distance matrix
dist.num = pdist(data);
% compute the multidimensional scaling
[Y,evals] = cmdscale(dist.num);

%% plot it!
% set plotting constants
graph.SCALE = 1.2;
graph.FS = 17;
graph.LW = 3;

% generate index matrix (itermNumber x time)
idx = nan(nObjs, nTimePts);
for itemNum = 1 : nObjs
    idx(itemNum,:) = (1 + (itemNum-1) * nTimePts) : (itemNum*nTimePts);
end

%% static MDS - 2d
if dimension == 2
    figure(1);
    % final time point MDS
    subplot(1,2,1)
    plot(Y(idx(:,targetTimePt),1),Y(idx(:,targetTimePt),2), 'rx', 'linewidth',graph.LW)
    mdsPlotModifier(Y, param, graph, idx);
    
    % temporal MDS
    subplot(1,2,2)
    hold on
    for itemNum = 1 : nObjs
        plot(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), 'g',  'linewidth', graph.LW/2)
        plot(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), 'b.', 'linewidth', graph.LW)
    end
    % mark the initial and final locations
    plot(Y(idx(:,1),1),Y(idx(:,1),2), 'rx', 'linewidth',graph.LW)
    plot(Y(idx(:,end),1),Y(idx(:,end),2), 'rx', 'linewidth',graph.LW)
    hold off
    mdsPlotModifier(Y, param, graph, idx);
    
elseif dimension == 3
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
else
    error('Dimension must be 2 OR 3.')
end


%% dynamicaly create MDS solutions
if doDynamicPlot
    figure(2);
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
