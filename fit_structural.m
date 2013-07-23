function fit = fit_structural(filename, estimateK)
% function fit = fit_structural(filename, estimateK)
%
% Returns the optimal structural model for a given data set.
%
% Parameters
% ----------
% filename : char
%   The filename of the file in the `data` folder. For example
%   `plant_01_run_01.mat`.
% estimateK : logical
%   If true process and measurement noise will be estimated in terms of a
%   Kalman gain matrix.
%
% Returns
% -------
% fit : idgrey
%   The optimal model.

plant_num = str2num(filename(7:8));

trDat = load_data(filename);
idDat = trDat(1:60000);
valDat = trDat(60001:end);

%advice(idDat)
%[FBCK, FBCK0, NUDIR] = feedback(dat)

nk = delayest(idDat);

% check out an ARX model

selections = struc(1:9, 1:9, 1:30);
loss = arxstruc(idDat, valDat, selections);
best = selstruc(loss, 0);

models.arxmod = arx(idDat, best);
models.arxmod.Name = sprintf('Best ARX [na=%u, nb=%u, nk=%u]', best);
display(models.arxmod.Name)

% build a grey box model
pars = importdata('data/initial_parameters.csv');
pars = pars.data(:, 2:end)';

models.result = find_structural_gains(idDat, pars(:, plant_num), plant_num, ...
    'estimateK', estimateK, 'warning', false);

generate_plots(plant_num, str2num(filename(14:15)), estimateK, valDat, models)

fit = models.result.fit;
