%% Visualize the classification accuracy over time
function visualizeAccuracies(score)
fontsize = 18;
LW = 3;
% Plot the CV accuracies against time
subplot(1,3,1)
score.response = score.response * 100;
plot(score.accuracy,'linewidth',LW)
ylim([(min(score.accuracy)-5) (max(score.accuracy)+5)])
xlabel('time', 'FontSize', fontsize)
ylabel('performance (%)', 'FontSize', fontsize)
title('Logistic regression accuracy against time', 'FontSize', fontsize)

% Plot the sum of absolute deviations (on the test set) against time
subplot(1,3,2)
plot(1 - score.deviation,'linewidth',LW)
ylim([(min(1 - score.deviation)-.05) (max(1 - score.deviation)+.05)])
xlabel('time', 'FontSize', fontsize)
ylabel('$1 - \sum | \mathrm{deviation \hspace{2mm} from \hspace{2mm} targets}|  \hspace{.5cm} (target \in \{0,1\})$', 'FontSize', fontsize,'Interpreter','latex')
title(' ''Fit ''against time', 'FontSize', fontsize)

subplot(1,3,3)
hold on 
plot(score.hitRate,'linewidth',LW/2)
plot(score.falseRate,'linewidth',LW/2)
plot(score.hitRate - score.falseRate,'linewidth', LW)
hold off 
legend({'hitRate', 'falseRate', 'hit-false'})
xlabel('time', 'FontSize', fontsize)
ylabel('%', 'FontSize', fontsize)
title('hit & false rate', 'FontSize', fontsize)

end