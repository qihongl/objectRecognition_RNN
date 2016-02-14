function [ subDataDirName ] = getSubDataDirName( PATH,FILENAME )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

tempStrs = strsplit(FILENAME.DATA, '_');
tempStrs = strsplit(tempStrs{2}, '.');
epoch = tempStrs{1};
subDataDirName = strcat(PATH.DATA_FOLDER, '_', epoch);

end

