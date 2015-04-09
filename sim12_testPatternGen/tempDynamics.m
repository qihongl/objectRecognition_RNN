clear;clc;clf;

% constants
interval = 26;

% read the data file 
temp = tdfread('verbalRepOut_e1.txt');
temp = temp.x0_0_00x2E000_00x2E000_00x2E000_00x2E000_00x2E000_00x2E000_00x2;
% temp = temp(547:end,:); % replicate on previous data set
% read the prototype pattern 
proto = xlsread('PROTO.xlsx');
proto = proto(2:end,:);
proto = logical(proto);
numInstances = size(proto,1);

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
    data{i + 1} = data{i + 1}(:,1:20);
    filData{i + 1} = data{i + 1}(:,proto(mod(i,4) + 1,:));
end

% get the data for each superordinate level category 
for i = numInstances : numInstances * 2 - 1;
    data{i + 1} = data{i + 1}(:,21:40);
    filData{i + 1} = data{i + 1}(:,proto(mod(i,4) + 1,:));
end

for i = numInstances * 2 : numInstances * 3 - 1;
    data{i + 1} = data{i + 1}(:,41:60);
     filData{i + 1} = data{i + 1}(:,proto(mod(i,4) + 1,:));
end

sup = filData{1}(:,1:4);
bas = filData{1}(:,5:8);
sub = filData{1}(:,9:10);

for i = 2:12;
    sup = [sup, filData{i}(:,1:4)];
    bas = [bas, filData{i}(:,5:8)];
    sub = [sub, filData{i}(:,9:10)];
end

mSup = mean(sup,2);
mBas = mean(bas,2);
mSub = mean(sub,2);


hold on 
plot(mSup,'g', 'linewidth', 2) 
plot(mBas,'r', 'linewidth', 2)
plot(mSub, 'linewidth', 2)

% xlim([0 26]);
% ylim([0 1]);
set(gca,'FontSize',11)
legend('Superordinate', 'Basic', 'Subordinate', 'location', 'southeast')
% legend('superordinate', 'basic', 'location', 'southeast')
set(legend,'FontSize',18);
title('Temporal dynamics of different level of concepts, 1000 epoch', 'fontSize', 18);
xlabel('Time Ticks', 'fontSize', 18)
ylabel('Activation Value', 'fontSize', 18)

hold off