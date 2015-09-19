%% superordinate classfication
% the OVERALL GOAL of this program is to convert a 'neural response' from
% ANN (in the form of a time series) and outputs a 'class' that represents
% a superordinate level category
function gs = main()

%% Specify the Path information (user needs to do this!)
PATH.PROJECT = '/Users/Qihong/Dropbox/github/categorization_PDP/';
% PATH.DATA_FOLDER = 'sim21.5_lessHidden';
PATH.DATA_FOLDER = 'sim16_large';
% provide the NAMEs of the data files (user need to set them mannually)
FILENAME.DATA = 'hiddenAll_e3.txt';
FILENAME.PROTOTYPE = 'PROTO.xlsx';

%% set some paramters


%% load the data and the prototype
[output, param] = loadData(PATH, FILENAME);

%% data preprocessing
% get activation matrices
activationMatrix = getActivationMatrices(output, param);
numTimePoints = size(activationMatrix,1);
% get labels
[~, Y] = getLabels(param);

% loop over all categories
numCategories = size(Y,2);
for j = 1 : numCategories
    %% attach labels
    data = attachLabels(activationMatrix, Y(:,j));
    
    %% Run MDS for all time points
    for i = 1 : numTimePoints
        

    end
end

end
