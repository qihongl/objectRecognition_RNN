function [] = plotPerformance_MVPA( data, propUsed, condition )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

legendNames = makeLegendNames(propUsed, condition);

% constant
d.FONTSIZE = 20;
d.LW = 3;
% Plot the CV accuracies against time
subplot(121)
% fig1 = figure(1);
% set(fig1, 'Position', [1000 1000 600 500])

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
subplot(122)
% fig2 = figure(2);
% set(fig2, 'Position', [1000 1000 600 500])
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
ylabel('reversed loss','FontSize', d.FONTSIZE);
% title_text = sprintf(' ''Fit '' - %s ', condition);
title_text = sprintf('Logistic regression, Fit | Semantic units | %s', condition);
title(title_text, 'FontSize', d.FONTSIZE)
set(gca,'FontSize',d.FONTSIZE)


% % subplot(2,2,3)
% figure(3)
% hold on 
% % plot(data.mean.hr,'linewidth',d.LW/2)
% % plot(data.mean.fr,'linewidth',d.LW/2)
% plot(data.mean.hr-data.mean.fr,'linewidth',d.LW)
% hold off
% legend(legendNames, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
% xlabel('time', 'FontSize', d.FONTSIZE)
% ylabel('%', 'FontSize', d.FONTSIZE)
% title_text = sprintf('(hit - false)rate  - %s', condition);
% title(title_text, 'FontSize', d.FONTSIZE)
% set(gca,'FontSize',d.FONTSIZE)
% %% 
% figure(4)
% verySmallNum = 1e-9;
% dp = norminv(data.mean.hr - 1e-9,0,1) - norminv(data.mean.fr + 1e-9,0,1);
% dp(isnan(dp)) = 0; 
% dp = dp(:,1:3); 
% plot(dp,'linewidth',d.LW + 1) 
% legendNames = {'1 unit', '2 units', '8 units'};
% % legendNames = {'1 group', '2 groups', '8 groups'};
% legend(legendNames, 'location', 'southeast', 'fontsize', d.FONTSIZE)
% 
% xlabel('Time', 'FontSize', d.FONTSIZE, 'FontWeight','bold')
% ylabel('d prime', 'FontSize', d.FONTSIZE, 'FontWeight','bold')
% title_text = sprintf('Logistic regression performance - %s', condition);
% % title(title_text, 'FontSize', d.FONTSIZE)
% set(gca,'FontSize',d.FONTSIZE)



end

