%% Plot MDS solution over time
% initialization
clear variables; clc; clf; 
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
PATH.SIMID = 'sim27.0_decay';
PATH.SIMID = 'sim27.1_varyNoise';
% PATH.SIMID = 'sim28.0_deep/00';
FILENAME.ACT = 'verbal_rapid_e10.txt';
% FILENAME.ACT = 'verbal_normal_e20.txt';
% FILENAME.ACT = 'verbalAll_e2.txt';
PATH.rep_idx = 1; 

FILENAME.PROTOTYPE = 'PROTO.xlsx';
nTimePts = 25;

%% read data
PATH.PROTOTYPE = genDataPath(PATH, FILENAME.PROTOTYPE);
[p, proto] = readPrototype(PATH.PROTOTYPE);
data = importData(PATH, FILENAME, p, nTimePts);
[average, baseline, reactionTime] = procData(data, p, nTimePts, proto); 

%% pre-compute values 
[avg, prob] = compute_mean_prob(average,baseline, p);

%% make plots 
clf
plotTempDynamics(avg, prob, FILENAME)