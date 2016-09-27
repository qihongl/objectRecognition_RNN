function [] = saveParams(parameters, visualPatterns, verbalPatterns, ...
                                protoParam, prototype)
% read the prototype used 
paramFile.prototype = prototype;
% read the actual patterns used 
paramFile.visualPatterns = visualPatterns;
paramFile.verbalPatterns = verbalPatterns;

% read the simulation parameters
param.envir = parameters;
param.proto = protoParam;
paramFile.params = param;

% save everything 
save paramFile.mat -struct paramFile

end

