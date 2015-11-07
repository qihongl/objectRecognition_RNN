clear all;close all;clc
path.root = '/Users/Qihong/Dropbox/github/categorization_PDP/';
path.dir = 'sim16_large';
path.file = 'hiddenFinal_e3.txt';
filename = [path.root path.dir '/' path.file];

X = dlmread(filename,' ', 0, 3);

RDM = computeRDM(X);

colormap jet
imagesc(RDM)
colorbar