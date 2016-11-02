%% process group score
% compute averages and error bars classification accuracies over time
% written for data generated by "runGroup.m"
clear; clc; clf; 

%% load file and compute summarized data
condition = 'randomSubset';
condition = 'spatBlurring';
% subDirName = 'sim22.2_RSVP_e2_30-Mar-2016_03';
% subDirName = 'sim23.2_noise_e2_22-Jun-2016';
subDirName = 'sim27.2_decay_rapid_e02_30-Oct-2016'

% combine path name
mainDirName = 'groupScores_class';
pathName = strcat(mainDirName,'/',subDirName);
% get file info
listing = dir([pathName '/gsClass_' condition '*.mat']);


%% read data files
% preallocate
numFiles = size(listing,1);
propUsed = cell(numFiles,1);
for i = 1:numFiles
    % load a data file
    fileName = listing(i).name;
    load([pathName '/' fileName])
    % build legend
    propUsed{i} = extractPropUsed(fileName, condition)/10;
    
    % compute means
    data.mean.acc(:,i) = mean(group.accuracy,2);
    data.mean.dev(:,i) = mean(group.deviation,2);
    data.mean.rep(:,i) = mean(group.response,2);
    data.mean.hr(:,i) = mean(group.hitRate,2);
    data.mean.fr(:,i) = mean(group.falseRate,2);
    % compute std (to build CI)
    data.sd.acc(:,i) = std(group.accuracy,0,2);
    data.sd.dev(:,i) = std(group.deviation,0,2);
    data.sd.rep(:,i) = std(group.response,0,2);
    data.sd.hr(:,i) = std(group.hitRate,0,2);
    data.sd.fr(:,i) = std(group.falseRate,0,2);
end



%% Visualize the classification accuracy over time
[legendNames] = makeLegendNames(propUsed, condition);

% constant
d.FONTSIZE = 20;
d.LW = 3;
% % Plot the CV accuracies against time
% % subplot(2,2,1)
fig1 = figure(1);
set(fig1, 'Position', [1000 1000 600 500])

plot(data.mean.acc,'linewidth',d.LW)
% hold on
% for i = 1 : numFiles
%     errorbar(data.mean.acc(:,i),data.sd.acc(:,i),'linewidth',d.LW)
% end
% hold off

legend(legendNames, 'location', 'SE', 'fontsize', d.FONTSIZE-2);


xlabel('time', 'FontSize', d.FONTSIZE)
ylabel('Classification accuracy (%)', 'FontSize', d.FONTSIZE)
title_text = sprintf('Logistic regression, Semantic units, %s', condition);
title(title_text, 'FontSize', d.FONTSIZE)
set(gca,'FontSize',d.FONTSIZE)


% Plot the sum of absolute deviations (on the test set) against time
% subplot(2,2,2)
figure(2)
plot(1 - data.mean.dev,'linewidth',d.LW)
% hold on
% for i = 1 : numFiles
%     errorbar(1 - data.mean.dev(:,i),data.sd.dev(:,i),'linewidth',d.LW)
% end
% hold off
legend(legendNames, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
xlabel('time', 'FontSize', d.FONTSIZE)
% ylabel(strcat( '$1 - \sum | \mathrm{deviation \hspace{2mm} from \hspace{2mm} targets}| ',...
%     ' \hspace{.5cm} (target \in \{0,1\})$'), 'FontSize', d.FONTSIZE,'Interpreter','latex')
ylabel('Absolute sum of deviation from the class label','FontSize', d.FONTSIZE);
% title_text = sprintf(' ''Fit '' - %s ', condition);
title_text = sprintf('Logistic regression, Fit | Semantic units | %s', condition);
title(title_text, 'FontSize', d.FONTSIZE)
set(gca,'FontSize',d.FONTSIZE)


% subplot(2,2,3)
figure(3)
hold on 
% plot(data.mean.hr,'linewidth',d.LW/2)
% plot(data.mean.fr,'linewidth',d.LW/2)
plot(data.mean.hr-data.mean.fr,'linewidth',d.LW)
hold off
legend(legendNames, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
xlabel('time', 'FontSize', d.FONTSIZE)
ylabel('%', 'FontSize', d.FONTSIZE)
title_text = sprintf('(hit - false)rate  - %s', condition);
title(title_text, 'FontSize', d.FONTSIZE)
set(gca,'FontSize',d.FONTSIZE)
%% 
figure(4)
verySmallNum = 1e-9;
dp = norminv(data.mean.hr - 1e-9,0,1) - norminv(data.mean.fr + 1e-9,0,1);
dp(isnan(dp)) = 0; 
dp = dp(:,1:3); 
plot(dp,'linewidth',d.LW + 1) 
legendNames = {'1 unit', '2 units', '8 units'};
% legendNames = {'1 group', '2 groups', '8 groups'};
legend(legendNames, 'location', 'southeast', 'fontsize', d.FONTSIZE)

xlabel('Time', 'FontSize', d.FONTSIZE, 'FontWeight','bold')
ylabel('d prime', 'FontSize', d.FONTSIZE, 'FontWeight','bold')
title_text = sprintf('Logistic regression performance - %s', condition);
% title(title_text, 'FontSize', d.FONTSIZE)
set(gca,'FontSize',d.FONTSIZE)

