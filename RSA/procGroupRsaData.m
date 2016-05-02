%% process group RSA score
% compute means and error bars for RSA correlation over time
% written for data generated by "runTemporalRSA_group.m"
clear; clc; 

%% where to read the data 
dataDir = strcat(pwd, '/groupScores_RSA/');
subDataDir = 'sim23.3_noise_e7_27-Apr-2016';

%% load file and compute summarized data
dataPath = strcat(dataDir,subDataDir);
condition1 = 'randomSubset';
[data.randSub] = summarizeTempRsaData(condition1,dataPath);
condition2 = 'spatBlurring';
[data.spatBlur] = summarizeTempRsaData(condition2,dataPath);


%% Plot the correlation against time
% constant
d.FONTSIZE = 18;
d.LW = 3;

% correlation with the basic matrix
figure(1)
subplot(1,3,1)
plot(data.randSub.mean.basic,'linewidth',d.LW)
ylim([0 1])
% hold on 
% for i = 1 : numFiles
%     errorbar(data.randSub.mean.basic(:,i),data.randSub.mean.basic(:,i),'linewidth',d.LW)
% end
% hold off
legend({'1%', '5%', '15%', '30%', '100%'}, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
xlabel('time', 'FontSize', d.FONTSIZE)
ylabel('Correlation', 'FontSize', d.FONTSIZE)
title('Correlation - basic matrix ', 'FontSize', d.FONTSIZE)

% correlation with the superordinate matrix
subplot(1,3,2)
plot(data.randSub.mean.super,'linewidth',d.LW)
ylim([0 1])
legend({'1%', '5%', '15%', '30%', '100%'}, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
xlabel('time', 'FontSize', d.FONTSIZE)
ylabel('Correlation', 'FontSize', d.FONTSIZE)
title('Correlation - super matrix', 'FontSize', d.FONTSIZE)

subplot(1,3,3)
plot(data.randSub.mean.basic - data.randSub.mean.super,'linewidth',d.LW)
legend({'1%', '5%', '15%', '30%', '100%'}, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
xlabel('time', 'FontSize', d.FONTSIZE)
ylabel('Difference', 'FontSize', d.FONTSIZE)
title('Difference(basic - super)', 'FontSize', d.FONTSIZE)


makeSupTitle_RSA(condition1, d, 0)


%% 2nd condition 
figure(2)
subplot(1,3,1)
plot(data.spatBlur.mean.basic,'linewidth',d.LW)
ylim([0 1])
legend({'1%', '5%', '15%', '30%', '100%'}, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
xlabel('time', 'FontSize', d.FONTSIZE)
ylabel('Correlation', 'FontSize', d.FONTSIZE)
title('Correlation - basic matrix', 'FontSize', d.FONTSIZE)

% correlation with the superordinate matrix
subplot(1,3,2)
plot(data.spatBlur.mean.super,'linewidth',d.LW)
ylim([0 1])
legend({'1%', '5%', '15%', '30%', '100%'}, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
xlabel('time', 'FontSize', d.FONTSIZE)
ylabel('Correlation', 'FontSize', d.FONTSIZE)
title('Correlation - super matrix', 'FontSize', d.FONTSIZE)

subplot(1,3,3)
plot(data.spatBlur.mean.basic - data.spatBlur.mean.super,'linewidth',d.LW)
legend({'1%', '5%', '15%', '30%', '100%'}, 'location', 'southeast', 'fontsize', d.FONTSIZE-2)
xlabel('time', 'FontSize', d.FONTSIZE)
ylabel('Difference', 'FontSize', d.FONTSIZE)
title('Difference(basic - super)', 'FontSize', d.FONTSIZE)

makeSupTitle_RSA(condition2, d, 0)