% add modifiers to names
function [names] = addPrefix(prefix, names, postfix)

    for i = 1 : size(names)
        names(i) = strcat(prefix, names(i), postfix);
    end

end