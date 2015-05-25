clear;clc;clf;
%% plot the temporal dynamics of the model behavior
% this program relies on the output file of 'testAllActs'
% it is designed to process the output for the verbal representation layer

%% constants
interval = 26;

% provide the NAMEs of the data files
DATAPATH = 'sim12_testPatternGen';
FILENAME = 'verbalAll_e1.txt';
PROTOTYPE = 'PROTO.xlsx';
EPOCH = 0;

%% read data
% read the output data
outputFile = tdfread([DATAPATH '/' FILENAME]);
name = char(fieldnames(outputFile));
output = getfield(outputFile, name);
% output = output(547:end,:); % replicate on previous data set

% read the prototype pattern 
proto = xlsread([DATAPATH '/' PROTOTYPE]);
proto = proto(2:end,:);
proto = logical(proto);
numInstances = size(proto,1) - 1;

%% preprocessing 
% add a zero row at the beginning so that every pattern has equal time
% length of 26
output = vertcat( zeros(1,size(output,2)), output);
% compute the number of stimuli
numStimuli = size(output,1) / 26;


% store all patterns into a cell array 
st = 1;
ed = interval;
data = cell(12,1);
for i = 1 : numStimuli
    data{i} = output(st + 1:ed,3:end);
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



%% plot the data
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
TITLE = sprintf('Temporal dynamics of different level of concepts, %d epoch', EPOCH); 
title(TITLE, 'fontSize', 18);
xlabel('Time Ticks', 'fontSize', 18)
ylabel('Activation Value', 'fontSize', 18)

hold off