function [avg, prob] = compute_mean_prob(average,baseline, p)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
avg.sup = mean(average.sup,2);
avg.bas = mean(average.bas,2);
avg.sup_base = mean(baseline.sup,2);
avg.bas_base = mean(baseline.bas,2);

prob.sup = avg.sup ./ (avg.sup + avg.sup_base * (p.numCategory.sup-1));
% prob.bas = avg.bas ./ (avg.bas + avg.bas_base * (p.numCategory.sup*p.numCategory.bas-1));
prob.bas = avg.bas ./ (avg.bas + avg.bas_base * (p.numCategory.bas-1));

prob.sup_base = avg.sup_base ./ (avg.sup + avg.sup_base * (p.numCategory.sup-1));
% prob.bas_base = avg.bas_base ./ (avg.bas + avg.bas_base * (p.numCategory.sup*p.numCategory.bas-1));
prob.bas_base = avg.bas_base ./ (avg.bas + avg.bas_base * (p.numCategory.bas-1));

end

