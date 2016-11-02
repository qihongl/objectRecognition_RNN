%% Write one input-output mapping to a file
% this program only works for my PDP model for semantics
%
% note: it assumes the file exists
%
% @parameter filename: the name of the file
% @parameter name: the name of the mapping
% @parameter length: the time length of the stimulus
% @parameter input: the input pattern
% @parameter tartget: the teaching pattern
function writeOnePattern(filename, name, length, input, target, visPos, ...
    supCat, param, targetType)

% modify the target patterns by masking out the corresponding "non-targets" 
thingsToBeMasked = param.thingsToBeMasked;
modifiedTarget = modifyTargetPattern(target, targetType, param, supCat, thingsToBeMasked);

% write the title of the mapping
fprintf(filename, 'name: %s \t %d\n', name, length);

% write the input and output pattern

%% 1st phase - stimuli presentation
fprintf(filename, 'I:\t');
if visPos == 1
    writeVisualVector(filename,input);
else
    writeVerbalVector(filename,input);
end

fprintf(filename, '\nT: ');
fprintf(filename, '');      % the 1st phase has no target

%% 2nd phase - stimuli & target presentation
fprintf(filename, '\nI:\t');
if param.rapidPresentation == false
    if visPos == 1
        writeVisualVector(filename,input);
    else
        writeVerbalVector(filename,input);
    end
end

fprintf(filename, '\nT:\t');
if visPos == 2
    writeVisualVector(filename,modifiedTarget);
else
    writeVerbalVector(filename,modifiedTarget);
end

fprintf(filename, '\n;\n\n');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function modifiedTarget = modifyTargetPattern(target, targetType, param, ...
    supCat, thingsToBeMasked)

allTargetTypes = {'visual_sup', 'visual_bas+sup', 'visual_all', ...
    'verbal_none', 'verbal_sup',  'verbal_bas', 'verbal_sub'};

% compute the mask 
mask = false(param.numUnits.total,1);
targetTypes = strsplit(targetType, '_');
if ~ismember(targetType, allTargetTypes) || length(targetTypes) ~= 2 
    error('ERROR: unrecognizable target type ');
else
    switch targetTypes{1}
        % dealing with visual target 
        case 'visual'            
            switch targetTypes{2}
                case 'sup'
                    mask(1:param.numUnits.sup) = true; 
                case 'bas+sup'
                    mask(1:(param.numUnits.sup+param.numUnits.bas)) = true; 
                case 'all'
                    mask = true(param.numUnits.total,1);
                otherwise
                    error('ERROR: unrecognizable target type ');
            end
        % dealing with verbal target 
%         case 'visual'
%             switch targetTypes{2}
%                 case 'sup'
%                     mask(1:param.numUnits.sup) = true; 
%                 case 'bas+sup'
%                     mask((param.numUnits.sup+1):(param.numUnits.sup+param.numUnits.bas)) = true; 
%                 case 'all'
%                     mask((param.numUnits.sup+param.numUnits.bas+1) : param.numUnits.total) = true; 
%                 otherwise
%                     error('ERROR: unrecognizable target type ');
%             end            
            
        % dealing with verbal target 
        case 'verbal'
            switch targetTypes{2}
                case 'none'
                    mask = true(param.numUnits.total,1);
                case 'sup'
                    mask(1:param.numUnits.sup) = true; 
                case 'bas'
                    mask((param.numUnits.sup+1):(param.numUnits.sup+param.numUnits.bas)) = true; 
                case 'sub'
                    mask((param.numUnits.sup+param.numUnits.bas+1) : param.numUnits.total) = true; 
                otherwise
                    error('ERROR: unrecognizable target type ');
            end
            
        otherwise
            error('ERROR: unrecognizable target type ');
    end
        
end

%% construct the final target pattern
if strcmp(thingsToBeMasked, 'otherLevels')
    mask = vertcat(mask,mask,mask);
    modifiedTarget = nan(1, length(mask));
    modifiedTarget(mask) = target(mask);
    
elseif strcmp(thingsToBeMasked, 'otherSupCategories')
    %% masking out alternative superordinate categories
    % the index for the current superordinate category 
    idx_curCat = ((supCat-1) * param.numUnits.total) + (1:param.numUnits.total);
    % preallocate the whole pattern to zeros 
    modifiedTarget = zeros(1,param.numCategory.sup * param.numUnits.total);
    % preallocate the current superordinate category section to NAN
    target_curCat_masked = nan(1,param.numUnits.total);

    % get the current superordinate category section 
    target_curCat = target(idx_curCat);
    % mask out irrelevant target (for other level of concepts )
    target_curCat_masked(mask) = target_curCat(mask);

    % get the final target 
    modifiedTarget(idx_curCat) = target_curCat_masked;
    
else 
    error('ERROR: unrecognized mask.')
end


end