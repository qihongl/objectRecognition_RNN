%% Plot MDS solution over time
% initialization
clear variables;  clc; clf; close all; 
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
PATH.SIMID = 'sim27.6_decay';
FILENAME.ACT = 'verbal_normal_e20.txt';
% FILENAME.ACT = 'verbal_rapid_e20.txt';
% FILENAME.ACT = 'verbalAll_e2.txt';

FILENAME.PROTOTYPE = 'PROTO.xlsx';
nTimePts = 25;

%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[p, proto] = readPrototype(PATH.PROTOTYPE);
data = importData(PATH, FILENAME, p, nTimePts);
[average, baseline] = readData(data, p, nTimePts); 

%% pre-compute values 
[avg, prob] = compute_mean_prob(average,baseline, p);

%% make plots 
clf
plotTempdyn(avg, prob, FILENAME)
