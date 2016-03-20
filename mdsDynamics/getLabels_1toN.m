%% read names from text data
function[labels_1toN] = getLabels_1toN(fname,N)

fileID = fopen(fname);
C = textscan(fileID,'%d %s %d %f %f %f %f %f %f %f %f');
fclose(fileID);

labels_1toN = C{2}(1:N);

end