function result = computeClassifierPerformance(y_hat, y_test, result)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% assuming threshold at .5 
y_pred = round(y_hat); 

% computer performnace 
result.accuracy = sum(y_pred == y_test) / length(y_test);
% deviation = L1 normDiff(prediction values, truth),more sensitive than accuracy
result.deviation = sum(abs(y_hat - y_test)) / length(y_test);
result.hitRate = sum(y_pred & y_test) / sum(y_test);
result.falseRate = sum(y_pred & ~y_test) / sum(~y_test);

end

