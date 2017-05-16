%% plot the histogram and integral curve for the reaction times
function [] = plotReacTimeHist(reactionTime, nTimePts)
% get constant
nStimuli = length(reactionTime);

% combine reaction time data
rt.sup = nan(nStimuli,1);
rt.bas = nan(nStimuli,1);
for i = 1 : nStimuli
    rt.sup(i) = reactionTime(i).sup;
    rt.bas(i) = reactionTime(i).bas;
end

%% plot
plotRTH_support(rt.sup, rt.bas, nTimePts, nStimuli)

end

% the plotting function 
function plotRTH_support(seq1, seq2, x_range, y_range)
g.LW = 2;
g.FS = 14;

figure(10)
% plot the reaction time distribution for seq1
subplot(2,2,1)
histogram(seq1, 'FaceColor', 'y')
xlim([0,x_range])
ylim([0,y_range])
title('Sup level naming')
ylabel('Frequency')
xlabel('time tick post stimuli onset')
set(gca,'FontSize',g.FS)

% plot the reaction time distribution for seq2
subplot(2,2,2)
histogram(seq2, 'FaceColor', 'r')
xlim([0,x_range])
ylim([0,y_range])
title('Basic level naming')
xlabel('time tick post stimuli onset')
set(gca,'FontSize',g.FS)

% plot the integral curve for seq1&2
subplot(2,2,3)
hold on
plot(integrateProb(seq1, x_range), 'y', 'linewidth', g.LW)
plot(integrateProb(seq2, x_range), 'r', 'linewidth', g.LW)
hold off
xlim([0,x_range])
ylim([0,100])
title('sum')
legend({'Sup', 'Basic'}, 'location', 'SE')
ylabel('sum')
xlabel('time tick post stimuli onset')
set(gca,'FontSize',g.FS)


    % helper function that integrates over time 
    function integral = integrateProb(rts, dim)
        % preallocate from 0 to 25 with max value!
        integral = ones(dim,1) * 100;
        %  then replace the initial part
        table = tabulate(rts);
        integral(1 : size(table,1)) = cumsum(table(:,3));
    end
end