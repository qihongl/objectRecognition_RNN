function [] = plotVerbalTemporalResponse(average, epochNum, PLOTALL)
p.LW = 4;
p.FS = 20;
if PLOTALL
    subplot(2,2,1)
    hold on
    % plot three temporal activation pattern
    plot(average.sup,'g', 'linewidth', p.LW)
    plot(average.bas,'r', 'linewidth', p.LW)
    % plot(mSub, 'linewidth', p.LW)
    hold off
    
    xlim([0 25]);
    % ylim([0 .5]);
    legend({'Superordinate', 'Basic'}, 'location', 'southeast', 'fontsize', p.FS, 'FontWeight','bold')
    title_text = sprintf('Verbal response');
    title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
    xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
    ylabel('Activation Value of Verbal Rep.', 'fontSize', p.FS, 'FontWeight','bold')
    set(gca,'FontSize',p.FS)
    
    %%
    subplot(2,2,2)
    
    prob.bas = average.bas ./ (average.sup + average.bas);
    prob.sup = average.sup ./ (average.sup + average.bas);
    hold on
    plot(prob.sup,'g', 'linewidth', p.LW)
    plot(prob.bas,'r', 'linewidth', p.LW)
    hold off
    
    ylim([0,1])
    % legend({'Superordinate', 'Basic'}, 'location', 'southeast', 'fontsize', p.FS, 'FontWeight','bold')
    title_text = sprintf('Luce Choice Probability');
    title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
    xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
    ylabel('Relative Probability', 'fontSize', p.FS, 'FontWeight','bold')
    set(gca,'FontSize',p.FS)
    
    %%
    subplot(2,2,3)
    
    % crossOverPt = find(min(abs(prob.bas - prob.sup)) == abs(prob.bas - prob.sup));
    
    % arbitarily chosen time points
    timeSections = [5 7 25];
    timeSecData = horzcat(prob.sup(timeSections),prob.bas(timeSections));
    
    mybar = bar(timeSecData);
    set(gca,'xticklabel',{'5','7','25'})
    
    mybar(1).FaceColor = 'g';
    mybar(2).FaceColor = 'r';
    
    title_text = sprintf('Time sections');
    title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
    xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
    ylabel('Relative Probability', 'fontSize', p.FS, 'FontWeight','bold')
    set(gca,'FontSize',p.FS)
    
    %%
    subplot(2,2,4)
    % mybar = bar(timeSecData);
    
    % set(gca,'xticklabel',{'t1','t2','t3'})
    % mybar(1).FaceColor = 'g';
    % mybar(2).FaceColor = 'r';
    
    title_text = sprintf('Empirical data');
    title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
    xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
    ylabel('--', 'fontSize', p.FS, 'FontWeight','bold')
    set(gca,'FontSize',p.FS)
    
    
    
else
    subplot(1,2,1)
    hold on
    % plot three temporal activation pattern
    plot(average.sup,'g', 'linewidth', p.LW)
    plot(average.bas,'r', 'linewidth', p.LW)
    % plot(mSub, 'linewidth', p.LW)
    hold off
    
    xlim([0 25]);
    ylim([0,1])
    legend({'Superordinate', 'Basic'}, 'location', 'southeast', 'fontsize', p.FS, 'FontWeight','bold')
    title_text = sprintf('EPOCH = %d', epochNum);
    title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
    xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
    ylabel('Activation Value of Verbal Rep.', 'fontSize', p.FS, 'FontWeight','bold')
    set(gca,'FontSize',p.FS)
    
    %%
    subplot(1,2,2)
    
    prob.bas = average.bas ./ (average.sup + average.bas);
    prob.sup = average.sup ./ (average.sup + average.bas);
    hold on
    plot(prob.sup,'g', 'linewidth', p.LW)
    plot(prob.bas,'r', 'linewidth', p.LW)
    hold off
    
    ylim([0,1])
    xlim([0,25])
    % legend({'Superordinate', 'Basic'}, 'location', 'southeast', 'fontsize', p.FS, 'FontWeight','bold')
    title_text = sprintf('Luce Choice Probability');
    title(title_text, 'fontSize', p.FS, 'FontWeight','bold');
    xlabel('Time', 'fontSize', p.FS, 'FontWeight','bold')
    ylabel('Relative Probability', 'fontSize', p.FS, 'FontWeight','bold')
    set(gca,'FontSize',p.FS)
    
    
end

end