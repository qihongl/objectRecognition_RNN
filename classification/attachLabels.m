%% attach appropriate response variable Y to the data set

% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category

function activationMatrix = attachLabels(activationMatrix, y)
% loop over all activation matrices (all time points)
for i = 1 : size(activationMatrix,1)
    % attach a column of response at the end
    activationMatrix{i} = [activationMatrix{i}, y];
end

% save('data', 'activationMatrix')
end
