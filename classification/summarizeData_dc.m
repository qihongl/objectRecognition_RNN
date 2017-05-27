%% summarize results for the dynamic code analysis
function [r, propUsed] = summarizeData_dc(listing, pathName, condition)
% get params
numFiles = size(listing,1);
propUsed = cell(numFiles,1);
filenames = lists2names(listing);

for i = 1:numFiles
    
    % load a data file
    load([pathName '/' filenames{i}])
    % build legend
    propUsed{i} = extractPropUsed(filenames{i}, condition)/10;
    % compute means
    ntps = length(result_dc);
    r(i).oritentation = 'by row'; 
    r(i).propUsed = propUsed{i}; 
    r(i).acc = nan(ntps, ntps);
    r(i).hmf = nan(ntps, ntps);
    for t = 1 : ntps
        % here, t-th row is the mvpa profile with the t-th tp model
        r(i).acc(t,:) = result_dc{t}.acc;
        r(i).hmf(t,:) = result_dc{t}.hr - result_dc{t}.fr;
    end
    

%     % visualize the results 
%     K = 3;
%     subplot(ceil(numFiles/step_size),2,i)
%     title_text = sprintf('accuracy(%d%%)',propUsed{i}); 
%     plotDecodingCurvesByCluster(temp.acc, K, title_text)
%     subplot(ceil(numFiles/step_size),2,i+1)
%     title_text = sprintf('hit-false(%d%%)',propUsed{i}); 
%     plotDecodingCurvesByCluster(temp.hmf, K, title_text)
end

end

% 
% %% helper function
% % plot the decoding curve for the model built from each time point, after
% % clustering their decoding accuracy profile with kmeans
% function plotDecodingCurvesByCluster(X, K, title_text)
% g.LW = 2;  
% clusters_idx = kmeans(X,K);
% hold on
% for k = 1 : K
%     % plor the accuracy profile by cluter 
%     mean_mvpa_profile_within_cluter = mean(X(clusters_idx == k,:),1); 
%     plot(mean_mvpa_profile_within_cluter, 'linewidth', g.LW)
%     % error bar 
% end
% hold off
% title(title_text)
% end
