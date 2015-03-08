function addTitle(filename, title)
    % parameter
    titleLength = 80;
    % write the title
    fprintf(filename, ['\n' repmat('#', [1,titleLength])  '\n']);
    fprintf(filename, [repmat('#', [1,titleLength])  '\n']);
    fprintf(filename, title);
    fprintf(filename, ['\n' repmat('#', [1,titleLength]) ]);
    fprintf(filename, ['\n' repmat('#', [1,titleLength])  '\n\n']);
end