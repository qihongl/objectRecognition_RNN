%% Plot MDS solution over time
% initialization
clear variables; clf; close all; clc;
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
% PATH.SIMID = 'sim23.2_noise';
% PATH.SIMID = 'sim25.2_RSVP';
% PATH.SIMID = 'sim26.2_initCond';
PATH.SIMID = 'sim27.0_maskTarget';
FILENAME.ACT = 'hiddenAll_e01.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

% set parameters
targetTimePt = 25;       % select from int[1,25]
graph.turnOnAxis = false;
graph.attachLabels = 0;
doDynamicPlot = 0;
graph.dimension = 3;
% stimulate properties of EEG
subsetSize = 156;
% method = 'spatialBlurring';
method = 'randomSubset';
method = 'normal';

% set plotting constants
graph.SCALE = 1.2;
graph.FS = 17;
graph.LW = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start
sprintf('Method: %s.\n', method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[param, ~] = readPrototype(PATH.PROTOTYPE);
[data, nTimePts] = importData( PATH, FILENAME, param);
nObjs = param.numStimuli;
% generate index matrix (itermNumber x time)
idx = reshape(1:size(data,1), [nTimePts,nObjs])';


%% compute 2 dimensional MDS
% simulate eeg-like senario: adding spatial noise or select random subset
data = eegSimulation(data, method, subsetSize, param);
% get unique numbers in the distance matrix
dist.num = pdist(data);
% compute the multidimensional scaling
[Y, evals] = cmdscale(dist.num);

%% plot it!
nObjs_sup = param.numCategory.bas*param.numCategory.sub;
col_supCat_idx = reshape(repmat(1:param.numCategory.sup, [nObjs_sup,1]), [nObjs,1]);
col_supCat = ['g', 'm', 'c'];
%% static MDS - 2d
if graph.dimension == 2
    
    % final time point MDS
    figure(3);
    hold on 
    for itemNum = 1 : nObjs
        plot(Y(idx(itemNum,targetTimePt),1),Y(idx(itemNum,targetTimePt),2), ...
            strcat(col_supCat(col_supCat_idx(itemNum)),'x'), 'linewidth',graph.LW)
    end
    hold off
    mdsPlotModifier(Y, param, graph, idx);
    
    % temporal MDS
    figure(4);
    hold on
    for itemNum = 1 : nObjs
        plot(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), ...
            col_supCat(col_supCat_idx(itemNum)),  'linewidth', graph.LW/2)
        plot(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), 'b.', 'linewidth', graph.LW)
        
        % mark the initial and final locations
        plot(Y(idx(itemNum,1),1),Y(idx(itemNum,1),2), 'rx', 'linewidth',graph.LW)
        plot(Y(idx(itemNum,end),1),Y(idx(itemNum,end),2), ...
            strcat(col_supCat(col_supCat_idx(itemNum)),'x'), 'linewidth',graph.LW)
    end
    hold off
    mdsPlotModifier(Y, param, graph, idx);
    
    %% hierach. clustering
    %     figure(5);
    %     tree = linkage(pdist(data(idx(:,end),:)));
    %     hc = dendrogram(tree, 'Labels', nameGen(param.numCategory),...
    %         'Orientation','left','ColorThreshold','default');
    %     set(hc,'LineWidth',graph.LW)
    
elseif graph.dimension == 3
    %% static plot - 3d
    figure(4)
    hold on
    for itemNum = 1 : nObjs
        % tarjectory
        plot3(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), Y(idx(itemNum,:),3), ...
            col_supCat(col_supCat_idx(itemNum)),  'linewidth', graph.LW/2)
        % point
        plot3(Y(idx(itemNum,:),1),Y(idx(itemNum,:),2), Y(idx(itemNum,:),3), ...
            'b.', 'linewidth', graph.LW)
        plot3(Y(idx(itemNum,1),1),Y(idx(itemNum,1),2), Y(idx(itemNum,1),3),...
            'rx', 'linewidth',graph.LW)
        plot3(Y(idx(itemNum,end),1),Y(idx(itemNum,end),2), Y(idx(itemNum,end),3),...
            strcat(col_supCat(col_supCat_idx(itemNum)),'x'), 'linewidth',graph.LW)
    end
    
    hold off
    mdsPlotModifier(Y, param, graph, idx);
else
    error('Dimension must be 2 OR 3.')
end


%% dynamicaly create MDS solutions
if doDynamicPlot
    figure(6);
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
set(gca,'position',[0 0 1 1],'units','normalized')
axis off