% Generate the names of the stimuli
function [names] = nameGen(numCategory)

% loop over 3 levels of names
for i = 1 : numCategory.sup
    name.sup = char(i + 'A' - 1);
    for j = 1 : numCategory.bas
    name.bas = num2str(j);
        for k = 1: numCategory.sub
            name.sub = num2str(k);
            % concatenate 3 levels 
            name.full = strcat(name.sup, name.bas, name.sub);
            % stack the names
            if exist('names') ~= 0 
                names  = [names; name.full];
            else
                names = name.full;
            end
        end
    end
end

names = cellstr(names);

end
