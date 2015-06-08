%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category

%% Initialization
clear ; close all; clc

%% Load Data
%  The first two columns contains the exam scores and the third column
%  contains the lab
data = load('data.mat');
data = data.activationMatrix;

numTimePoints = size(data,1);
accuracy = nan(numTimePoints, 1);

for i = 1 : numTimePoints
    accuracy(i) = logisticReg(data{i});
end

plot(accuracy)