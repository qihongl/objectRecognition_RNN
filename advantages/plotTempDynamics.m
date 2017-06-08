%% Visualize the activation profiles of the verbal layer 
function [ output_args ] = plotTempDynamics(act, prob, FILENAME)
% graph param 
g.LW = 2; 
g.FS = 14; 

figure(1)
% raw activation 
subplot(221)
hold on 
plot(act.sup, 'r', 'linewidth',g.LW)
plot(act.bas,'b', 'linewidth',g.LW)
plot(act.sup_base, '--r', 'linewidth',g.LW)
plot(act.bas_base, '--b','linewidth',g.LW)
hold off 
title('Verbal Activation')
xlabel('Time ticks');ylabel('Mean Activation')
legend({'Sup-target','Basic-target','Sup-nontargets','Basic-nontarget'}, 'location', 'best')
% ylim([0 .7])
set(gca,'FontSize',g.FS)

subplot(222)
% substraction plot 
hold on; 
plot(act.sup - act.sup_base, 'r', 'linewidth',g.LW); 
plot(act.bas - act.bas_base, 'b', 'linewidth',g.LW); 
hold off 
title('Substraction')
xlabel('Time ticks');ylabel('Mean Activation')
legend({'Sup','Basic'}, 'location', 'best')
set(gca,'FontSize',g.FS)


% luce choice probability 
subplot(223)

hold on 
plot(prob.sup, 'r', 'linewidth',g.LW)
plot(prob.bas, 'b', 'linewidth',g.LW)
plot(prob.sup_base, '--r', 'linewidth',g.LW)
plot(prob.bas_base, '--b', 'linewidth',g.LW)

hold off 
xlabel('Time ticks');
ylabel('Probability')
title('Luce Probability')
legend({'Sup-target','Basic-target','Sup-nontargets','Basic-nontarget'}, 'location', 'best')
set(gca,'FontSize',g.FS)

subplot(224)
% substraction plot 
hold on; 
plot(prob.sup - prob.sup_base, 'r', 'linewidth',g.LW); 
plot(prob.bas - prob.bas_base, 'b', 'linewidth',g.LW); 
hold off 
title('Substraction')
xlabel('Time ticks');
ylabel('Probability')
legend({'Sup','Basic'}, 'location', 'best')
set(gca,'FontSize',g.FS)


suptitle_text = strrep(sprintf('%s', FILENAME.ACT), '_', '-');
suptitle(suptitle_text)

%%
figure(3)
hold on 
% plot(cumsum(prob.sup), 'r', 'linewidth',g.LW)
% plot(cumsum(prob.bas), 'b', 'linewidth',g.LW)
% plot(cumsum(prob.sup_base), '--r', 'linewidth',g.LW)
% plot(cumsum(prob.bas_base), '--b', 'linewidth',g.LW)
plot(cumsum(prob.sup), 'r', 'linewidth',g.LW)
plot(cumsum(prob.bas), 'b', 'linewidth',g.LW)
hold off 
%% show the difference 

% figure(2)
% subplot(121)
% hold on 
% plot(avg.sup-avg.sup_base, 'r', 'linewidth',g.LW)
% plot(avg.bas-avg.bas_base,'b', 'linewidth',g.LW)
% hold off 
% set(gca,'FontSize',g.FS)
% 
% xlabel('Time ticks');ylabel('Activation'); 
% 
% subplot(122)
% hold on 
% plot(prob.sup-prob.sup_base, 'r', 'linewidth',g.LW)
% plot(prob.bas-prob.bas_base,'b', 'linewidth',g.LW)
% hold off 
% xlabel('Time ticks');ylabel('Probability'); 
% legend({'Sup','Basic'}, 'location', 'best')
% set(gca,'FontSize',g.FS)
% 
% suptitle('difference(targ,nonTarg)')

end

