%% This function takes the parameters and generates the labels
% *: this is designed for one-vs-all classification (binary classification
% don't really need it).

function [labels, Y] = getLabels(param)
    %% check parameters
    checkParameters(param)

    %% generate labels as a matrix
    for i = 1 : param.numCategory.sup
        if i == 1
            Y = ones(param.numInstances,1);
        else 
            Y = dsum(Y,ones(param.numInstances,1));
        end
    end

    %% save the information in a structure
    for i = 1 : param.numCategory.sup
        % assign the category name (from A, B, C, ... )
        categoryName = upper(char(i +'a'-1));
        % split the Y
        labels.(categoryName) = Y (:,i);
    end

end


%% check if the parameters are consistent within
function checkParameters(param)
    if param.numInstances * param.numCategory.sup ~= param.numStimuli
        error('Number of instances * number of superclasses != number of total stimuli!')
    elseif param.numUnits.total ~= ...
            param.numUnits.sub + param.numUnits.bas + param.numUnits.sup
        error('Number of total units inconsistent with the sum over 3 levels of units')
    end
end
