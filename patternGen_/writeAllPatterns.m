function writeAllPatterns(filename, names, stimulusLength, inputPatterns, targetPatterns, visPos)
    if size(targetPatterns,1) ~= size(inputPatterns,1)
        disp('ERROR, input and output dimension mismatch')
    else
        for i = 1: size(targetPatterns,1);
            % name of one stimulus
            stimulusName = char(names(i)); 
            % pick input and ouput mapping
            input = inputPatterns(i,:);
            target = targetPatterns(i,:);
            % write one input to output mapping to file
            writeOnePattern(filename, stimulusName, stimulusLength, input, target, visPos)
        end
    end
end