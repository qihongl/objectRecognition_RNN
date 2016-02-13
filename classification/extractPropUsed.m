function [ propUsed ] = extractPropUsed( fileName, condition )
%Extract the proportion units used, for creating legends
index = strfind(fileName, condition);
propUsed = sscanf(fileName(index(1) + length(condition):end), '%g', 1);
end

