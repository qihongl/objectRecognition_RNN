function writeAllPatterns(filename, names, stimulusLength, inputPatterns,...
    targetPatterns, param, targetType, visPos)

if size(targetPatterns,1) ~= size(inputPatterns,1)
    error('ERROR, input and output dimension mismatch')
else
    
    numInstances = param.numInstances;
    for i = 1: size(targetPatterns,1);
        
        % figure out the super ordinate class (assume there are exactly 3 classes)
        if i/numInstances <= 1
            supCat = 1;
        elseif i/numInstances <= 2
            supCat = 2;
        elseif i/numInstances <= 3
            supCat = 3;
        else
            error('ERROR, undefined classes');
        end
        
        % name of one stimulus
        stimulusName = char(names(i));
        % pick input and ouput mapping
        input = inputPatterns(i,:);
        target = targetPatterns(i,:);
        % write one input to output mapping to file
        writeOnePattern(filename, stimulusName, stimulusLength, input, target, visPos,...
            supCat, param, targetType)
    end
end
end