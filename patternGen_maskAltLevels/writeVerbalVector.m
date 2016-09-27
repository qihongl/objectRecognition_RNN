%% writeVerbalVector: it write a vector to a file
% It insert space between every element in the vector, in order for lens to
% read. This function is used for write a single pattern to the environment
% file. 
% 
% @parameter filename: the name of the file you want to write
% @parameter vector: the vector you want to write
function writeVerbalVector(filename, vector)
    
    SEPARATOR = ' ';
    ZERO = '0';
    BLANK = '-';
    
    % verbal section 
    for i = 1: size(vector,2)
        if vector(i)~= 1 && vector(i)~= 0  && ~isnan(vector(i))
            error('Input pattern is neither 0 or 1.')
        elseif vector(i) == 1               % print '1' iff input is 1
            fprintf(filename, '%d', vector(i));
        elseif vector(i) == 0               
            fprintf(filename, '%s', ZERO);
        elseif isnan(vector(i))
            fprintf(filename, '%s', BLANK);
        end
        fprintf(filename, SEPARATOR); % sep by space
    end
    
    fprintf(filename, '\n\t');
    
    % visual section 
    for i = 1: size(vector,2)
        fprintf(filename, BLANK);
        fprintf(filename, SEPARATOR);
    end
end