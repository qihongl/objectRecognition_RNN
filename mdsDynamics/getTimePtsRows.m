function [ timePtsRows ] = getTimePtsRows( timePt, nObjs, nQs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
timePtsRows = (1:nObjs) + timePt * nQs;
end

