%% Write one input-output mapping to a file
% this program only works for my PDP model for semantics
% 
% note: it assumes the file exists
%
% @parameter filename: the name of the file
% @parameter name: the name of the mapping
% @parameter length: the time length of the stimulus
% @parameter input: the input pattern
% @parameter tartget: the teaching pattern 
function writeOnePattern(filename, name, length, input, target, visPos)

    % write the title of the mapping 
    fprintf(filename, 'name: %s \t %d\n', name, length);
    
    % write the input and output pattern
    
    % 1st phase
    fprintf(filename, 'I:\t');
    if visPos == 1
        writeVisualVector(filename,input);
    else
        writeVerbalVector(filename,input);
    end
    
    fprintf(filename, '\nT: ');
    fprintf(filename, '');  % leave blank
    
    % 2nd phase
    fprintf(filename, '\nI:\t');
    if visPos == 1
        writeVisualVector(filename,zeros(1,size(input,2)));
    else
        writeVerbalVector(filename,zeros(1,size(input,2)));
    end
    
    fprintf(filename, '\nT:\t');
    if visPos == 2
        writeVisualVector(filename,zeros(1,size(input,2)));
    else
        writeVerbalVector(filename,zeros(1,size(input,2)));
    end
    
    fprintf(filename, '\n;\n\n');

end