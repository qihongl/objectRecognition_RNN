function writeAllPatterns(filename, names, stimulusLength, inputPatterns,...
    targetPatterns, param, targetType, visPos)

if size(targetPatterns,1) ~= size(inputPatterns,1) || ... 
    size(targetPatterns,1) ~= param.numStimuli || ...
    size(inputPatterns,1) ~= param.numStimuli
    error('ERROR, input/output dimension mismatch')
else
    
    numInstances = param.numInstances;
    for i = 1: param.numStimuli
        % figure out the super ordinate class (assume class cardinality eq)
        supCat = ceil(i/numInstances); 
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