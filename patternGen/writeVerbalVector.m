%% writeVerbalVector: it write a vector to a file
% It insert space between every element in the vector, in order for lens to
% read. This function is used for write a single pattern to the environment
% file. 
% 
% @parameter filename: the name of the file you want to write
% @parameter vector: the vector you want to write
function writeVerbalVector(filename, vector)
    
    separator = ' ';

    for i = 1: size(vector,2)
        if vector(i)~= 1 && vector(i)~= 0   % make sure the input is 1 or 0
            error('Input pattern is neither 0 or 1.')
        elseif vector(i) == 1               % print '1' iff input is 1
            fprintf(filename, '%d', vector(i));
        elseif vector(i) == 0               % print '-' iff input is 0
            fprintf(filename, '%s', '-');
        end
        fprintf(filename, separator); % sep by space
    end
    
    fprintf(filename, '\n\t');
    for i = 1: size(vector,2)
        fprintf(filename, '-');
        fprintf(filename, separator);
    end
end