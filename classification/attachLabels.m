%% attach appropriate response variable Y to the data set

% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category

function activationMatrix = attachLabels(activationMatrix, param)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% assume binary classifcation! This would not generalize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = [ones(param.numInstances,1); zeros(param.numInstances,1)];

for i = 1 : size(activationMatrix,1)
    activationMatrix{i} = [activationMatrix{i}, y];
end

% save('data', 'activationMatrix')
end
