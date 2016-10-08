%% writeParameters
function writeParameters(filename, parameters, pattern)    

    fprintf(filename, '# Some modeling details:\n');
    
    fprintf(filename, '# Seed value = %d \n', parameters.seed);
    
    fprintf(filename, '# total number of units: %d \n', pattern.numTotalUnits);
    fprintf(filename, '# - number of superordinate units: %d \n', pattern.numUnits.sup);
    fprintf(filename, '# - number of basic units: %d \n', pattern.numUnits.bas);
    fprintf(filename, '# - number of subordinate units: %d \n', pattern.numUnits.sub);
    fprintf(filename,'\n');
    
    fprintf(filename, '# total number of instances: %d \n', pattern.numTotalInstances);
    fprintf(filename, '# - number of superordinate level categories: %d \n', pattern.numCategory.sup);
    fprintf(filename, '# - number of basic level categories: %d \n', pattern.numCategory.bas);
    fprintf(filename, '# - number of subordinate level categories: %d \n', pattern.numCategory.sub);
    fprintf(filename,'\n');
    
    fprintf(filename, '# verbalProbabilityThreshold: %.2f \n', parameters.verbalThres);
    fprintf(filename, '# visualProbabilityThreshold: %.2f \n', parameters.visualThres);
    fprintf(filename, '# seed value: %d \n', parameters.seed);
    
    fprintf(filename, '\n');
    % TODO : check the existence
    % TODO : complete all possible parameters 
    % TODO : check extreme values    
    
    fprintf(filename, 'defI: %d \n', parameters.defI);
    if isnan(parameters.defT)
        fprintf(filename, 'defT: - \n');
    else
        fprintf(filename, 'defT: %.1f \n', parameters.defT);
    end
    fprintf(filename, 'actI: %d \n', parameters.actI);
    fprintf(filename, 'actT: %d \n', parameters.actT);
    fprintf(filename, 'min: %.1f \n', parameters.min);
    fprintf(filename, 'max: %.1f \n', parameters.max);
    fprintf(filename, 'grace: %.1f \n', parameters.grace);
    fprintf(filename, ';\n');

end