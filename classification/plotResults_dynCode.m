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
figure(1)
% plot both accuracy and hit - false 
% for c = 1 : step_size : nConds
%     % plot accuracy
%     subplot(ceil(nConds/step_size),2,c)
%     title_text = sprintf('accuracy (%d%%)',propUsed{c});
%     plotDecodingCurvesByCluster(data(c).acc, K, title_text)
%     % plot hit-false rate
%     subplot(ceil(nConds/step_size),2,c+1)
%     title_text = sprintf('hit-false (%d%%)',propUsed{c});
%     plotDecodingCurvesByCluster(data(c).hmf, K, title_text)
% end
% suptitle_text = sprintf('%s, K means (K == %d)', condition, K);
% suptitle(suptitle_text);

cs = [1,3,5]; 
for i = 1 : ceil(nConds / step_size)
    % plot hit-false rate
    subplot(ceil(nConds / step_size), 1, i)
    title_text = sprintf('hit-false (%.1f%%)',propUsed{cs(i)});
    plotDecodingCurvesByCluster(data(cs(i)).hmf, K, title_text)
end
suptitle_text = sprintf('%s, K means (K == %d)', condition, K);
suptitle(suptitle_text);

% HC
% figure(2)
% for c = 1 : step_size : nConds
%     subplot(ceil(nConds/step_size),2,c)
%     [hout,T,perm] = dendrogram(linkage(squareform(pdist(data(c).acc))));
%     title_text = sprintf('acc (%d%%)',propUsed{c});
%     title(title_text);
%     
%     subplot(ceil(nConds/step_size),2,c+1)
%     [hout,T,perm] = dendrogram(linkage(squareform(pdist(data(c).hmf))));
%     title_text = sprintf('hit-false (%d%%)',propUsed{c});
%     title(title_text);
% end
% suptitle_text = sprintf('%s, HC', condition);
% suptitle(suptitle_text);
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
% compute a clustering
clusters_idx = kmeans(X,K);
[leg, indices] = getLegend(clusters_idx);
line_colors = varycolor(K);
hold on
for k = 1 : K
    % plor the accuracy profile by cluter
    mean_mvpa_profile_within_cluter = mean(X(clusters_idx == k,:),1);
    plot(mean_mvpa_profile_within_cluter, ...
        'linewidth', g.LW, 'color', line_colors(indices(k),:))
    % error bar
    % ...
    plot(leg.int{k}, 1.05,'.','markersize',30,'color', line_colors(indices(k),:))
end
ylim([0 1.05])
% legend(leg.str)
hold off
title(title_text)
xlabel('Time ticks')
end

function [leg, indices] = getLegend(clusters_idx)
nClusters = max(clusters_idx);
leg.str = cell(nClusters,1);
leg.int = cell(nClusters,1);
for i = 1 : nClusters
    temp_idx = find(clusters_idx==i);
    
    % create the legend for the i-th cluster
    temp_leg.str = '';
    temp_leg.int = [];
    for ii = 1 : length(temp_idx)
        % get the next legend
        temp_leg.str = strcat(temp_leg.str, num2str(temp_idx(ii)));
        temp_leg.int = [temp_leg.int, temp_idx(ii)];
        if ii ~= length(temp_idx)
            temp_leg.str = strcat(temp_leg.str, ',');
        end
    end
    leg.str{i} = temp_leg.str;
    leg.int{i} = temp_leg.int;
end

indices = sort_cluster_by_time(leg.int);
end


function indices = sort_cluster_by_time(cluster_leg_int)
nClusters = length(cluster_leg_int);

cluster_mean_time = nan(nClusters,1);
for i = 1 : nClusters
    cluster_mean_time(i) = mean(cluster_leg_int{i});
end
cluster_mean_time_sorted = sort(cluster_mean_time);

indices = nan(nClusters,1);
for i = 1 : nClusters
    indices(i) = find(cluster_mean_time(i) == cluster_mean_time_sorted);
end
end



% % hierarchical clustering
% function clusters_idx = hc(X)
%
%
% end
