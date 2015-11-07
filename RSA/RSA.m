% initialize 
clear all;close all;clc
path.root = '/Users/Qihong/Dropbox/github/categorization_PDP/';
path.dir = 'sim22.0_RSVP';
path.file = 'hiddenFinal_e3.txt';
filename = [path.root path.dir '/' path.file];

%% start
% load the activation matrix
X = dlmread(filename,' ', 0, 3);
% compute RDM
RDM = computeRDM(X);
% plot it 
colormap jet
img = imagesc(RDM);
colorbar

%%
imname = sprintf('RDM%.3d', 1);
mkdir([path.dir '_RDM'])

print(imname,'-dpng');