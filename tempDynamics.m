%% plot the temporal dynamics of the model behavior
% this program relies on the output file of 'testAllActs'
% it is designed to process the output for the verbal representation layer

% MORE ABOUT THE EXPERIEMENT:
% the model sees the visual representation for all objects, and its verbal
% patterns were recorded.

%% CONSTANTS
clear;clc;clf;
INTERVAL = 26;
PATH.ABS = '/Users/Qihong/Dropbox/github/PDPmodel_Categorization/';

% provide the NAMEs of the data files (user need to set them mannually)
PATH.DATA= 'sim15_repPrev';
FILENAME.VERBAL = 'verbalAll_e1.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';
EPOCH = 1000;


%% read data
% read the output data
PATH.FULL = [PATH.ABS PATH.DATA];
% check if the data file exists
if exist([PATH.FULL '/' FILENAME.VERBAL], 'file') == 0
    error([ 'File ' FILENAME.VERBAL ' not found.'])
end
outputFile = tdfread([PATH.FULL '/' FILENAME.VERBAL]);
name = char(fieldnames(outputFile));
output = getfield(outputFile, name);
% output = output(547:end,:); % replicate on previous data set

% read the prototype pattern, to get some parameters of the simulation
[numUnits, numCategory, numInstances, prototype] = readPrototype ([PATH.FULL '/' FILENAME.PROTOTYPE]);
numStimuli = numInstances * numCategory.sup;
numTotalUnits = sum(struct2array(numUnits));
prototype = logical(prototype);

%% preprocessing
% add a zero row at the beginning so that every pattern has equal numRows
output = vertcat( zeros(1,size(output,2)), output);
% split the data
data = mat2cell(output, repmat(INTERVAL, [1 numStimuli]), size(output,2) );
for i = 1 : size(data,1)
    data{i} = data{i}(:, 3:end);    % remove the 1st & 2nd columns
    data{i} = data{i}(2:end,:);     % remove the 1st row of zeros
end

% check the number of stimuli
if numStimuli ~= size(output,1) / INTERVAL
    error ('number of stimuli are wrong')
end

% % plot the data
% for i = 1 : numStimuli
%     subplot(numCategory.sup,numInstances,i)
%     imagesc(data{i})
% end

%% get the 'right' part of the output data
% let's say a model has 60 units that represents classes A, B and C. If
% object A11 only activates the first 20 units. The remaining 40 units will
% not be included when analyzing the activation dynamics of all objects
% that belongs to class A

filteredData = cell(12,1);
currClass = 1;
for i = 1 : numStimuli
    % increment the index that controls the peudo-inner loop
    index = mod(i - 1,numInstances) + 1;
    
    % check if current class is bigger than the number of super.category
    if(currClass > numCategory.sup)
        error('wtf')
    end
    
    % subset the data using the 'right' part of the units
    first = (currClass - 1) * numTotalUnits + 1;
    last = numTotalUnits + (currClass -1) * numTotalUnits;
    % filter by the 'right' class
    filteredData{i} = data{i}(:, first : last);
    % filter by the 'right' set of units
    filteredData{i} = filteredData{i}(:, prototype(index,:));
    
    % print the indices (for debugging purpose)
    % fprintf('%d %d %d to %d\n', i, index, first, last)
    
    % if I have went through all instances in a class...
    if(index == numInstances)
        currClass = currClass + 1;  % go to the next class
    end
end

% plot the data

% for i = 1 : numStimuli
%     subplot(numCategory.sup,numInstances,i)
%     imagesc(filteredData{i})
% end


%%  divide the data according to super, basic, and sub level (across all stimuli)

% the parameters here depends on the number of units that suppose to be on
% for each concept level. 
% This can be seen from every prototype pattern. 
% (It assumes every pattern activates the same number of super, basic, sub units)

% pick whatever prototype pattern
onePrototype = prototype(1,:);
% compute the number of units that are on for every conpcet level
on.sup = sum(onePrototype(1:numUnits.sup));
on.bas = sum(onePrototype(numUnits.sup + 1 : numUnits.sup + numUnits.bas));
on.sub = sum(onePrototype(numUnits.sup + numUnits.bas + 1 : numTotalUnits));

% divide the data according to the concept level
sup = filteredData{1}(:,1:on.sup);
bas = filteredData{1}(:,on.sup + 1 : on.sup + on.bas);
sub = filteredData{1}(:,on.sup + on.bas + 1 : on.sub);
for i = 2:numStimuli;
    sup = [sup, filteredData{i}(:,1:on.sup)];
    bas = [bas, filteredData{i}(:,on.sup + 1 : on.sup + on.bas)];
    sub = [sub, filteredData{i}(:,on.sup + on.bas + 1 : on.sup + on.bas + on.sub)];
end

%%  compute the mean activation value for all time points
mSup = mean(sup,2);
mBas = mean(bas,2);
mSub = mean(sub,2);


%% plot the data! 
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