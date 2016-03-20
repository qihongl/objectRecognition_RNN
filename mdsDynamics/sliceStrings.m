% slice names by the same char
function [slicedStr] = sliceStrings(str)

slices = strsplit(str,'_');
slicedStr = slices(1);

end