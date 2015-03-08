clear;clc;clf;

% constants
interval = 26;
numStimuli = 33;
numNaming = 12;
superEnd = 4;
basicEnd = 4 + 8;
subEnd = 20;
nameLength = 20;

temp = tdfread('verbalRepOut_e3a005.txt');
temp = temp.x0_0_00x2E500_00x2E500_00x2E500_00x2E500_00x2E500_00x2E500_00x2;
proto = xlsread('PROTO.xlsx');
proto = logical(proto);


% make the index one-based 
temp(:,1) = temp(:,1) + 1;
% only need visualTOverbal data
tempNamingData = temp(temp(:,1) > 21,:);


%% re-format the data
namingData = cell(1,12);
i = 1;
for j = 1:12
    namingData{j} = tempNamingData(i : interval * j, 3:end);
    i = i + interval;
end

% category A
for j = 1:4
    namingData{j} = namingData{j}(:,1:nameLength);
end

% category B
for j = 5:8
    namingData{j} = namingData{j}(:,21:40);
end

% category B
for j = 9:12
    namingData{j} = namingData{j}(:,41:60);
end


filData = cell(1,10);
j = -1;
for i = 1:12
    j = j + 1;
    s = mod(j,4) + 1;
    filData{i} = namingData{i}(:,proto(s,:));
end



sup = filData{i}(:,1:4);
bas = filData{i}(:,5:8);
sub = filData{i}(:,9:10);

for i = 2:12;
    sup = [sup, filData{i}(:,1:4)];
    bas = [bas, filData{i}(:,5:8)];
    sub = [sub, filData{i}(:,9:10)];
end

mSup = mean(sup(2:end,:),2);
mBas = mean(bas(2:end,:),2);
mSub = mean(sub(2:end,:),2);


hold on 
plot(mSup,'r', 'linewidth', 2) 
plot(mBas,'g', 'linewidth', 2)
plot(mSub, 'linewidth', 2)

% xlim([0 26]);
% ylim([0.1 1]);
legend('superordinate', 'basic', 'subordinate', 'location', 'southeast')
% legend('superordinate', 'basic', 'location', 'southeast')
set(legend,'FontSize',15);
% title('Temporal dynamics for different level of mental categories', 'fontSize', 17);
title('x epochs','FontSize',18)
xlabel('time ticks', 'fontSize', 15)
ylabel('activation value', 'fontSize', 15)

hold off