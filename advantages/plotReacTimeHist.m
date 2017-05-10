function [] = plotReacTimeHist(reactionTime, nTimePts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

g.LW = 2; 
g.FS = 14; 

figure(10)

nStimuli = length(reactionTime); 

rt.sup = nan(nStimuli,1);
rt.bas = nan(nStimuli,1);

for i = 1 : nStimuli
    rt.sup(i) = reactionTime(i).sup;
    rt.bas(i) = reactionTime(i).bas;
end


%% plot 
subplot(1,2,1)
histogram(rt.sup, 'FaceColor', 'y')
xlim([0,nTimePts])
ylim([0,nStimuli])
title('Sup level naming')
ylabel('Frequency')
xlabel('time tick post stimuli onset')
set(gca,'FontSize',g.FS)

subplot(1,2,2)
histogram(rt.bas, 'FaceColor', 'r')
xlim([0,nTimePts])
ylim([0,nStimuli])
title('Basic level naming')
xlabel('time tick post stimuli onset')
set(gca,'FontSize',g.FS)

end

