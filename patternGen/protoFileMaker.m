%% generate the prototype file in csv form 
clear; clc; close all; 
% the number of active unit at each level of category 
nActUnits = 2; 
nSupCat = 2; 
nLevels = 3; 

% gen param 
proto = protoFileGen(nActUnits, nSupCat, nLevels);
imagesc(proto); 