% Builds data from folder full of 3-D quench data (propagation prob)
% (with parameter header). Searches 'PROP*.dat', and returns a struct array
% containing pretty much all the useful information you can think of.
%
% Requires normal_analysis.m

function repo = PROP_build_data()
% Define go criterion
go_threshold = 0.9;
% Get data
D = dir('PROP*.dat');
% For each file in data
for i = 1:length(D)
    % Grab data
    dat = importdata(D(i).name,'\t',1);
    % If data came in a struct, separate data and textdata
    if isempty(dat)
        continue
    end
    if ~isstruct(dat)
        error(['No header found in ' 'D(i).name']);
    end
    % Extract data
    param = dat.textdata;
    if iscell(param)
        param = param{1};
    end
    num_data = dat.data;
    % Sort data
    num_data = sortrows(num_data,1);
    % Filter out empty entries or NaNs
    num_data = num_data(~sum(isnan(num_data),2),:);
    % Separate numerical data
    xi = num_data(:,1);
    
%     assert(length(xi) == 1);
    
    progress_percentage = num_data(:,2:end);
    % Get parameter information to initialize data item
    item = get_parameter_struct(param);
    % Check data repo for bin with existing parameters
    repo_index = -1;
    % Get length of repository, if it exists
    if i == 1
        len_repo = 0;
    else
        len_repo = length(repo);
    end
    % Check if entry exists in repo
    for j = 1:len_repo 
        % Check if repository entry j has parameters same as item
        if has_param(item,repo(j))
            repo_index = j;
            break
        end
    end
    
    % Override%%%%%%%%%%%%%%%%%%%%%%%%%% override to split all runs
%     repo_index = -1;
    
    % If no existing bin was found
    if repo_index == -1
        % Assign a new index
        repo_index = len_repo+1;
        % Create data 
        item.xi = [];
        item.progress_percentage = [];
        % Push item to repository
        repo(repo_index) = item;
    end
    % Check equality of xi vector with the one in repo
    if isempty(repo(repo_index).xi)
        repo(repo_index).xi = xi;
    else
        assert(isequal(xi, repo(repo_index).xi));
    end
    % Append data to repo entry
    repo(repo_index).progress_percentage = ...
        [repo(repo_index).progress_percentage progress_percentage];
end

% Exit if no repo was created
if ~exist('repo','var')
    return
end

% Binarize
for i = 1:length(repo)
    % Binarize
    go_matrix = repo(i).progress_percentage > go_threshold;
    % Average propagation percentage
    repo(i).propagation_probability = sum(go_matrix,2)/size(go_matrix,2);
end

for i = 1:length(repo)
    % Calculate critical dimension
    [critical_dimension, ci, characteristic_scale]=...
    normal_analysis(repo(i).xi, repo(i).propagation_probability);
    repo(i).critical_dimension = critical_dimension;
    repo(i).ci = ci;
    repo(i).characteristic_scale = characteristic_scale;
    % Bind plots
    repo(i).plot = @() plot(repo(i).xi,...
        repo(i).propagation_probability);
    % Split ci for convenience
    repo(i).ci_lower = ci(1);
    repo(i).ci_upper = ci(2);
end



% Sort by theta_ign
[~,index] = sortrows([repo.theta_ign].'); repo = repo(index);
% Sort by geometry
[~,index] = sortrows({repo.geometry}.'); repo = repo(index);


% Parses parameter string and returns struct of parameters
function param_struct =  get_parameter_struct(param)
% Test data
% param = '{seed:12342}{tign:0.2}{tauc:20}';

% Find tokens (assumes header's {} written in correct pairs)
lefts = regexp(param,'{');
rights = regexp(param,'}');
tokens = cell(1,length(lefts));
% Split parameter string into tokens
for i = 1:length(lefts)
    tokens{i} = param(lefts(i)+1:rights(i)-1);
end
% Divide each token into key and value, assign to struct
for i = 1:length(tokens)
    token = tokens{i};
    % Find separator
    sep_index = regexp(token,':');
    key = token(1:sep_index-1);
    value = token(sep_index+1:end);
    % If contents of string is numerical
    if ~isnan(str2double(value))
        value = str2double(value);
    end
    eval(['param_struct.' key '=value;'] );
end

% Checks if struct param's contents is a subset of struct item
function flag =  has_param(param_struct, item)
fn = fieldnames(param_struct);
flag = true;
for i = 1:length(fn)
    if ~isequal(param_struct.(fn{i}), item.(fn{i}));
        flag = false;
        return
    end
end