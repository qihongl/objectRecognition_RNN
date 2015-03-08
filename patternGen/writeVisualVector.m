function writeVisualVector(filename, vector)

    separator = ' ';
    for i = 1: size(vector,2)
        fprintf(filename, '-');
        fprintf(filename, separator);
    end
    fprintf(filename, '\n\t');
    for i = 1: size(vector,2)
        fprintf(filename, '%d', vector(i));
        fprintf(filename, separator); 
    end

end