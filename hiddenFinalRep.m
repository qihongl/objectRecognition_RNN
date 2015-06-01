%% CONSTANTS
clear;clc;clf;
PATH.ABS = '/Users/Qihong/Dropbox/github/PDPmodel_Categorization/';

% provide the NAMEs of the data files (user need to set them mannually)
PATH.DATAFOLDER = 'sim15_repPrev';
PATH.DATAFILE = 'hiddenFinal_e3.txt'; 

PATH.FULL = [PATH.ABS  PATH.DATAFOLDER '/' PATH.DATAFILE];

outputFile = tdfread(PATH.FULL);
name = char(fieldnames(outputFile));
output = getfield(outputFile, name);