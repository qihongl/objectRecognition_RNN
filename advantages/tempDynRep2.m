%% Plot MDS solution over time
% initialization
clear variables; clc; close all; 
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% provide the NAMEs of the data files (user need to set them mannually)
PATH.SIMID = 'sim27.0_decay';
PATH.SIMID = 'sim27.1_varyNoise';
% PATH.SIMID = 'sim29.0_simple';
FILENAME.ACT = 'verbal_normal_e20.txt';
% FILENAME.ACT = 'verbal_normal_e04.txt';
% FILENAME.ACT = 'verbalAll_e2.txt';
PATH.rep_idx = 0; 

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
plotReacTimeHist(reactionTime, nTimePts)