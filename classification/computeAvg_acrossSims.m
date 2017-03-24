function data = computeAvg_acrossSims(data_sub)

% compute mean 
data.mean.acc = zeros(size(data_sub{1}.mean.acc));
data.mean.dev = zeros(size(data_sub{1}.mean.dev));
data.mean.hr = zeros(size(data_sub{1}.mean.hr));
data.mean.fr = zeros(size(data_sub{1}.mean.fr));
for i = 1 : numel(data_sub)
    data.mean.acc = data.mean.acc + data_sub{i}.mean.acc; 
    data.mean.dev = data.mean.dev + data_sub{i}.mean.dev; 
    data.mean.hr = data.mean.hr + data_sub{i}.mean.hr; 
    data.mean.fr = data.mean.fr + data_sub{i}.mean.fr; 
end
data.mean.acc = data.mean.acc / numel(data_sub); 
data.mean.dev = data.mean.dev / numel(data_sub); 
data.mean.hr = data.mean.hr / numel(data_sub); 
data.mean.fr = data.mean.fr / numel(data_sub); 

% compute sd 
data.sd.acc = zeros(size(data_sub{1}.mean.acc));
data.sd.dev = zeros(size(data_sub{1}.mean.dev));
data.sd.hr = zeros(size(data_sub{1}.mean.hr));
data.sd.fr = zeros(size(data_sub{1}.mean.fr));

% for i = 1 : numel(data_sub)
%     data.sd.acc = 
%     data.sd.dev = 
%     data.sd.rep = 
%     data.sd.hr = 
%     data.sd.fr = 
% end


end

