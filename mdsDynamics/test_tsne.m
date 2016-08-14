% Load data
clear all 
load mnist_train.mat
train_X = digits';

nPts = 2000;

ind = randperm(size(train_X, 1));
train_X = train_X(ind(1:nPts),:);
train_labels = labels(ind(1:nPts));
% Set parameters
no_dims = 2;
initial_dims = 50;
perplexity = 30;
% Run t-SNE
mappedX = tsne(train_X, [], no_dims, initial_dims, perplexity);
% Plot results
gscatter(mappedX(:,1), mappedX(:,2), train_labels);