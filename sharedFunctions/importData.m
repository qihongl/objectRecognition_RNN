function [data] = importData( PATH, FILENAME, param, nTimePts)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% read prototype and parameters

% read data
PATH.DATA = fullfile(PATH.PROJECT,PATH.SIMID, sprintf('%.2d',PATH.rep_idx),FILENAME.ACT);
data = dlmread(PATH.DATA,' ', 0,2);
data(:,size(data,2)) = []; % last column are zeros (reason unknown...)
data(1 + (0:param.numStimuli-1)*(nTimePts+1),:) = []; % remove zero rows

end

