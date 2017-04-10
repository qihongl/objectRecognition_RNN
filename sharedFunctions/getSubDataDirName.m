function [ subDataDirName ] = getSubDataDirName( PATH,FILENAME )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

tempStrs = strsplit(FILENAME.DATA, '_');
epoch = strsplit(tempStrs{3}, '.');
epoch = epoch{1};
tempStrs = strcat(tempStrs{2},'_',epoch);
subDataDirName = strcat(PATH.DATA_FOLDER, '_', tempStrs, '_', sprintf('%.2d',PATH.rep_idx));

end

