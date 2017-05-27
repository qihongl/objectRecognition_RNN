function [filenames] = lists2names(listing)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n = length(listing);
filenames = cell(n,1);
for i = 1 : n
    filenames{i} = listing(i).name;
end

end

