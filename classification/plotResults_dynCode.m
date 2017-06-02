%% plot the decoding profiles for the dynamic code analysis
function [] = plotResults_dynCode(results, propUsed, condition, K)
%% summarize the data
data = preallocate(results);
% sum
nConds = length(results{1});
for c = 1 : nConds;
    for i = 1 : length(results)
        data(c).acc = data(c).acc + results{i}(c).acc;
        data(c).hmf = data(c).hmf + results{i}(c).hmf;
    end
end
% normalize
for c = 1 : length(results{i})
    data(c).acc = data(c).acc / length(results);
    data(c).hmf = data(c).hmf / length(results);
end

%% visualize the results
step_size = 2; 
for c = 1 : step_size : nConds
    
    subplot(ceil(nConds/step_size),2,c)
    title_text = sprintf('accuracy (%d%%)',propUsed{c});
    plotDecodingCurvesByCluster(data(c).acc, K, title_text)
    
    subplot(ceil(nConds/step_size),2,c+1)
    title_text = sprintf('hit-false (%d%%)',propUsed{c});
    plotDecodingCurvesByCluster(data(c).hmf, K, title_text)
end
suptitle_text = sprintf('%s, K means (K == %d)', condition, K); 
suptitle(suptitle_text); 

end


%% helper function
% get the number of time points
function [data] = preallocate(results)
nConds = length(results{1});
for c = 1 : nConds
    data(c).prop = results{1}(c).propUsed;
    data(c).acc = zeros(size(results{1}(1).acc));
    data(c).hmf = zeros(size(results{1}(1).hmf));
end
end

% plot the decoding curve for the model built from each time point, after
% clustering their decoding accuracy profile with kmeans
function plotDecodingCurvesByCluster(X, K, title_text)
g.LW = 2;
clusters_idx = kmeans(X,K);
hold on
for k = 1 : K
    % plor the accuracy profile by cluter
    mean_mvpa_profile_within_cluter = mean(X(clusters_idx == k,:),1);
    plot(mean_mvpa_profile_within_cluter, 'linewidth', g.LW)
    % error bar
end
hold off
title(title_text)
xlabel('Time ticks')
end