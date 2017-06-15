% test the function preproc
clear variables; clc; close all;
for nHiddens = 3 : 80
    fprintf('%d ', nHiddens);
    % constants
    nStimuli = 48;
    
    % set arbitrary values
    param.subsetProp = .3;
    param.collapseTime = false;
    param.var = 0;
    param.classOpt = 'spatBlurring';
%     param.classOpt = 'randomSubset';
    X = randn(nStimuli, nHiddens);
    
    % run the function
    [X_subset, info] = preprocess(X, param);
    
    % test if they are the same
    X_rep = preprocess_rep(X, info, param.classOpt); 
    if ~all(all(X_rep == X_subset))
        disp('DIFFERENT!')
    end
end