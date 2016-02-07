% plot RDM correlation over all time points
function [] = plotTemporalCorr_RDM()

FONTSIZE = 14;
LW = 1.5;
% Plot the data
hold on
plot(temporalCorr.basic, 'linewidth', LW)
plot(temporalCorr.super, 'linewidth', LW)
hold off

% add text 
legend({'basic theoretical matrix', 'super theoretical matrix'}, 'location', 'southeast', 'fontsize', FONTSIZE)
title('RDM correlation over time, x presentation', 'fontsize', FONTSIZE)
xlabel('Time', 'fontsize', FONTSIZE)
ylabel('Correlation', 'fontsize', FONTSIZE)
end