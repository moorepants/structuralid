function run(plants, runs, estimate_noise)
% function run(plants, runs, estimate_noise)
%
% Runs a set of identifications for given plant and run numbers.
%
% Parameters
% ----------
% plants : double, 1 x N
%   A list of the plant numbers you'd like to identify.
% runs : char or double, N x M
%   Either the 'all' or an array of run numbers for each plant.
% estimate_noise : char, {'yes'|'no'|'both'}
%   If 'yes' then the full K matrix will be estimated. If 'no' then the K
%   matrix will be set to a zero matrix. If 'both', then the identifications
%   will be run for both cases.

% TODO : give an 'all' option for the plants

for plant_indice = 1:length(plants)

    plant_num = plants(plant_indice);

    if runs == 'all'
        available_runs = find_available_runs(plant_num, 'data');
    else
        available_runs = runs(:, plant_indice);
    end

    for run_num = available_runs

        if strcmp(estimate_noise, 'yes')
            estimation_flags = 1;
        elseif strcmp(estimate_noise, 'no')
            estimation_flags = 0;
        elseif strcmp(estimate_noise, 'both')
            estimation_flags = 0:1;
        end

        for j = estimation_flags

            if j == 0
                kay = 'no';
            elseif j == 1
                kay = 'yes';
            end

            display(sprintf('Plant #%u,  Run #%u, K estimated: %s', ...
                plant_num, run_num, kay))

            models = fit_structural(['plant_' sprintf('%0.2d', plant_num) '_run_' ...
                sprintf('%0.2d', run_num) '.mat'], j);
            display(repmat('-', 1, 79))
        end
    end
end
