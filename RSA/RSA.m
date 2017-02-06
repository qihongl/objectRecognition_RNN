% initialize
clear all;clf;clc
path.root = '/Users/Qihong/Dropbox/github/categorization_PDP/';
path.dir = 'sim23.2_noise';
% path.dir = 'sim27.17_decay';
% path.dir = 'sim22.2_RSVP';
path.file = 'hiddenFinal_e2.txt';
filename = [path.root path.dir '/' path.file];

%% start
% load the activation matrix
X = dlmread(filename,' ', 0, 3);
% compute RSM
RSM = computeRSM(X);
% plot it
colormap jet
img = imagesc(1-RSM);
set(gca, 'XTick', [], 'YTick', [],'dataAspectRatio',[1 1 1])

h=colorbar;
set(h,'fontsize',14);
h.Ticks = [];
% title_text = sprintf('%s-%s',path.dir, path.file);
% title(title_text)
% set(gca,'position',[0 0 1 1],'units','normalized')

%% customize ticks
% ax = gca;
% ax.XTick = 1:48;
% ax.YTick = 1:48;
% ax.XTickLabel = {'1','2','3','4'};
% ax.YTickLabel = {'1','2','3','4'};

%%
% imname = sprintf('RSM%.3d', 1);
% mkdir([path.dir '_RDM'])
% print(imname,'-dpng');

%% compute cohesiveness & distinctiveness
len.bas = 4;
len.sup = 16;
nCat.bas = 4;
nCat.sup = 3;

similarity = computeSimilarity(RSM,nCat,len);
% average across super classes 
meanValues = mean(similarity,3); 
% compute average within category simiarlity
cohesiveness = mean(meanValues(logical(eye(size(meanValues)))))
% compute average between category simiarlity
distinctiveness = mean(meanValues(~logical(eye(size(meanValues)))))
catBoundEffect = cohesiveness - distinctiveness

