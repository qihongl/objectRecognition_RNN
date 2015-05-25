clear;clc;clf;

% constants
interval = 26;

% read the data file 
% temp = tdfread('verbalRepOut_e05a001.txt');
temp = tdfread('/Users/Qihong/Dropbox/github/PDPmodel_Categorization/sim15.1_repPrev/verbalAll_e1.txt');
temp = temp.x0_0_00x2E000_00x2E000_00x2E000_00x2E000_00x2E000_00x2E000_00x2;
% temp = temp(547:end,:); % replicate on previous data set
% read the prototype pattern 
temp2 = xlsread('/Users/Qihong/Dropbox/github/PDPmodel_Categorization/sim15.1_repPrev/PROTO.xlsx');
% temp2 = xlsread('PROTO3.xlsx');
numUnits.sup = temp2(1,1);
numUnits.bas = temp2(1,2);
numUnits.sub = temp2(1,3);
numCategory.sup = temp2(1,4);
numCategory.bas = temp2(1,5);
numCategory.sub = temp2(1,6);
numUnits.all = numUnits.sup + numUnits.bas + numUnits.sub;
proto = temp2(2:end,:);
proto = logical(proto);
numInstances = size(proto,1) - 1;

% preprocessing 
% add a zero row at the beginning so that every pattern has equal time
% length of 26
temp = vertcat( zeros(1,size(temp,2)), temp);
% compute the number of stimuli
numStimuli = size(temp,1) / 26;


% store all patterns into a cell array 
st = 1;
ed = interval;
data = cell(12,1);
for i = 1 : numStimuli
    data{i} = temp(st + 1:ed,3:end);
    st = st + interval;
    ed = ed + interval;
end

% filter the data with the prototype 
filData = cell(12,1);
for i = 0 : numInstances - 1;
    data{i + 1} = data{i + 1}(:,1:numUnits.all);
    filData{i + 1} = data{i + 1}(:,proto(mod(i,4) + 1,:));
end

% get the data for each superordinate level category 
for i = numInstances : numInstances * 2 - 1;
    data{i + 1} = data{i + 1}(:,numUnits.all + 1 : numUnits.all * 2);
    filData{i + 1} = data{i + 1}(:,proto(mod(i,4) + 1,:));
end

for i = numInstances * 2 : numInstances * 3 - 1;
    data{i + 1} = data{i + 1}(:,numUnits.all * 2 + 1 : numUnits.all * 3);
     filData{i + 1} = data{i + 1}(:,proto(mod(i,4) + 1,:));
end

sup = filData{1}(:,1:4);
bas = filData{1}(:,5:6);
sub = filData{1}(:,7);

for i = 2:12;
    sup = [sup, filData{i}(:,1:4)];
    bas = [bas, filData{i}(:,5:6)];
    sub = [sub, filData{i}(:,7)];
end

mSup = mean(sup,2);
mBas = mean(bas,2);
mSub = mean(sub,2);


hold on 
plot(mSup,'r', 'linewidth', 2) 
plot(mBas,'g', 'linewidth', 2)
plot(mSub, 'linewidth', 2)

xlim([0 26]);
% ylim([0 1]);
legend('superordinate', 'basic', 'subordinate', 'location', 'southeast')
% legend('superordinate', 'basic', 'location', 'southeast')
set(legend,'FontSize',14);
title('Temporal dynamics for different level of mental categories', 'fontSize', 17);
xlabel('time ticks', 'fontSize', 14)
ylabel('activation value', 'fontSize', 14)

hold off