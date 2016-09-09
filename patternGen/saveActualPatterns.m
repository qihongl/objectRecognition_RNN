function [] = saveActualPatterns(parameters, visualPatterns, verbalPatterns, protoName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

actualPatterns.visualPatterns = visualPatterns;
actualPatterns.verbalPatterns = verbalPatterns;

[protoparam, prototype] = readPrototype (protoName);
actualPatterns.prototype = prototype;

param.envir = parameters;
param.proto = protoparam;
actualPatterns.params = param;

save actualPatterns.mat -struct actualPatterns

end

