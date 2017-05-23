%% generate the prototype file in csv form 
clear; clc; close all; 
% the number of active unit at each level of category 
nActUnits = 2; 
nCat = 2; 
nLevels = 3; 
fname = 'PROTO'; 

% gen prototype
proto = protoFileGen(fname, nActUnits, nCat, nLevels);
