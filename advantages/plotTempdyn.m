function [ output_args ] = plotTempdyn(avg, prob, FILENAME)


g.LW = 2; 
g.FS = 14; 

figure(1)
% raw activation 
subplot(121)
hold on 
plot(avg.sup, 'r', 'linewidth',g.LW)
plot(avg.bas,'b', 'linewidth',g.LW)
plot(avg.sup_base, '--r', 'linewidth',g.LW)
plot(avg.bas_base, '--b','linewidth',g.LW)
hold off 
title('Verbal Activation')
xlabel('Time ticks');ylabel('Mean Activation')
legend({'Sup-target','Basic-target','Sup-nontargets','Basic-nontarget'}, 'location', 'best')
% ylim([0 .7])
set(gca,'FontSize',g.FS)


% luce choice probability 
subplot(122)

hold on 
plot(prob.sup, 'r', 'linewidth',g.LW)
plot(prob.bas, 'b', 'linewidth',g.LW)
plot(prob.sup_base, '--r', 'linewidth',g.LW)
plot(prob.bas_base, '--b', 'linewidth',g.LW)

hold off 
xlabel('Time ticks');ylabel('Probability w.r.t alternatives')
title('Luce Probability')
legend({'Sup-target','Basic-target','Sup-nontargets','Basic-nontarget'}, 'location', 'best')
set(gca,'FontSize',g.FS)

suptitle_text = strrep(sprintf('%s', FILENAME.ACT), '_', '-');
suptitle(suptitle_text)


%% show the difference 

figure(2)
subplot(121)
hold on 
plot(avg.sup-avg.sup_base, 'r', 'linewidth',g.LW)
plot(avg.bas-avg.bas_base,'b', 'linewidth',g.LW)
hold off 
set(gca,'FontSize',g.FS)

xlabel('Time ticks');ylabel('Activation'); 

subplot(122)
hold on 
plot(prob.sup-prob.sup_base, 'r', 'linewidth',g.LW)
plot(prob.bas-prob.bas_base,'b', 'linewidth',g.LW)
hold off 
xlabel('Time ticks');ylabel('Probability'); 
legend({'Sup','Basic'}, 'location', 'best')
set(gca,'FontSize',g.FS)

suptitle('difference(targ,nonTarg)')

end

