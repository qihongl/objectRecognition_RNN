function [ ] = checkAndMkdir( dirName )
%UNTITLED3 Summary of this function goes here

% check if a given data dir exists
% if not, create it 
if exist(dirName,'dir') ~= 7
    mkdir(dirName)
else
    warning(strcat('Directory: <', dirName, '> exists!'))
end
end

