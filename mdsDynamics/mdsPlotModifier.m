function mdsPlotModifier(Y, param, graphParam, idx)
% add title
title_text = 'Classical Metric Multidimensional Scaling over time';
title(title_text, 'fontsize', graphParam.FS)
set(gca,'FontSize',graphParam.FS)
% squareform plot
axis(max(max(abs(Y))) * [-1,1,-1,1] * graphParam.SCALE); axis('square');


%% additional graphic elemetns...
if graphParam.attachLabels
    % generate labels
    labels = nameGen(param.numCategory);
    for i = 1 : length(labels)
        tempSlices = strsplit(labels{i},'_');
        labels{i} = tempSlices(1);
    end
    % attach labels at the right coordinates
    text(Y(idx.final,1),Y(idx.final,2),labels, ...
        'HorizontalAlignment','left', 'fontsize', graphParam.FS);
end

if graphParam.turnOnAxis
    line([-1,1],[0 0],'XLimInclude','off','Color',[.7 .7 .7])
    line([0 0],[-1,1],'YLimInclude','off','Color',[.7 .7 .7])
end

end