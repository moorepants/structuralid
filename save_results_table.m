function save_results_table(filepath, plant_num, run_num, estimate_k, ...
    models, grey_vaf, arx_vaf)
% function save_results_table(filepath, plant_num, run_num, estimate_k, ...
%    models, grey_vaf, arx_vaf)
%
% Creates a csv file with the results of the identification. It will replace
% or append based on the plant number, run number, and noise estimation,
% which make the results unique.
%
% Parameters
% ----------
% filepath : char
%   The path to the csv file.
% plant_num : double
%   The plant number.
% run_num : double
%   The run number.
% estimate_k : boolean
%   Whether the noise was estimated or not.
% models : structure
%   Contains 'mod', 'fit', and 'arxmod' id models.
% grey_vaf : double
%   The grey box identification's variance accounted for with respect to the
%   validation data.
% arx_vaf : double
%   The arx identification's variance accounted for with respect to the
%   validation data.

uncert = diag(models.fit.cov(1:4, 1:4));

row = [plant_num,
       run_num,
       estimate_k,
       size(models.mod.A, 1)
       models.fit.par(1),
       uncert(1),
       models.fit.par(2),
       uncert(2),
       models.fit.par(3),
       uncert(3),
       models.fit.par(4),
       uncert(4),
       grey_vaf / 100.0,
       % TODO : the following will fail with orders that have more than two
       % digits
       str2num(models.arxmod.Name(14)),
       str2num(models.arxmod.Name(20)),
       str2num(models.arxmod.Name(26)),
       arx_vaf / 100.0];

formats = {'%d',
           '%d',
           '%d',
           '%d',
           '%1.4f',
           '%1.4f',
           '%1.4f',
           '%1.4f',
           '%1.4f',
           '%1.4f',
           '%1.4f',
           '%1.4f',
           '%1.4f',
           '%d',
           '%d',
           '%d',
           '%1.4f'};

headers = {'plant',
           'run',
           'noise',
           'order',
           'k1',
           'sigma_k1',
           'k2',
           'sigma_k2',
           'k3',
           'sigma_k3',
           'k4',
           'sigma_k4',
           'grey_vaf',
           'arx_na',
           'arx_nb',
           'arx_nb',
           'arx_vaf'};

try
    current = importdata(filepath, ',');
catch err
    if (strcmp(err.identifier, 'MATLAB:importdata:FileNotFound'))
        display(sprintf('%s does not exist, creating new file.', filepath))
        fid = fopen(filepath, 'w');
        fprintf(fid, '%s\n', strjoin(headers', ','));
        fprintf(fid, [strjoin(formats', ',') '\n'], row');
        fclose(fid);
        % break from this function
        return
    else
        rethrow(err);
    end
end

replaced = false;
[rows, cols] = size(current.data);
for i = 1:rows
    if current.data(i, 1) == plant_num && current.data(i, 2) == run_num ...
        && current.data(i, 3) == estimate_k
       display(sprintf('Replacing a row %d with new data in %s.', i, ...
           filepath))
       current.data(i, :) = row';
       replaced = true;
    end
end

if ~replaced
    display(sprintf('Appending a new row or %s.', filepath))
    current.data(rows + 1, :) = row';
end

% sort by the first three columns
updated = sortrows(current.data, [1, 2, 3]);

% rewrite the file
fid = fopen(filepath, 'w');
fprintf(fid, '%s\n', strjoin(headers', ','));
fprintf(fid, [strjoin(formats', ',') '\n'], updated');
fclose(fid);
