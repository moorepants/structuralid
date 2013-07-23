function runs = find_available_runs(plant_num, data_directory)
% function runs = find_available_runs(plant_num, data_directory)
%
% Parameters
% ----------
% plant_num : double
%   The plant number you'd like to search for available runs.
% data_directory : char
%   A directory path which contains files named in the plant_00_run_00.mat
%   pattern.
%
% Returns
% -------
% runs : double, 1 x n
%   An array of all the runs available for this plant. If empty, there are
%   no runs for that plant.

stuff = what(data_directory);
runs = [];
j = 1;
for i = 1:length(stuff.mat)
    filename = stuff.mat{i};
    if strcmp(filename(1:6), 'plant_') && str2num(filename(7:8)) == plant_num
        runs(j) = str2num(filename(14:15));
        j = j + 1;
    end
end
