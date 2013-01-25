function fit = fit_structural(filename, estimateK)
% function fit = fit_structural(filename, estimateK)
%
% Returns the optimal structural model for a given data set.
%
% Parameters
% ----------
% filename : char
%   The filename of the file in the `data` folder. For example
%   `jason_1.mat`.
% estimateK : logical
%   If true process and measurement noise will be estimated in terms of a
%   Kalman gain matrix.
%
% Returns
% -------
% fit : idgrey
%   The optimal model.

warning off
modelNum = str2num(filename(7));
raw = load(['data/' filename]);

dat = iddata(raw.theta, raw.theta_c, 0.0005, ...
             'InterSample', 'foh', ...
             'InputName', {'thetac'}, ...
             'OutputName', {'theta'});
trDat = detrend(dat);

idDat = trDat(1:60000);
valDat = trDat(60001:end);

%advice(idDat)
%[FBCK, FBCK0, NUDIR] = feedback(dat)

nk = delayest(idDat);

% check out an ARX model

selections = struc(1:9, 1:9, 1:30);
loss = arxstruc(idDat, valDat, selections);
best = selstruc(loss, 0);

arxmod = arx(idDat, best);
arxmod.Name = sprintf('Best ARX [na=%u, nb=%u, nk=%u]', best);
display(arxmod.Name)

% build a grey box model
pars = importdata('data/initial_parameters.csv');
pars = pars.data(:, 2:end)';

result = find_structural_gains(idDat, pars(:, modelNum), modelNum, ...
    'estimateK', estimateK);

% create a plot directory if one doesn't already exist
if exist('plots/', 'dir') ~= 7
    mkdir('plots/')
end

if estimateK
    kay = '-K';
else
    kay = '';
end

compare(valDat, arxmod, result.mod, result.fit)
saveas(gcf(), ['plots/compare-' num2str(modelNum) kay '.png'])
close all

bode(arxmod, 'sd', 1, 'fill', result.mod, result.fit, 'sd', 1, 'fill', {0.1, 100})
saveas(gcf(), ['plots/theta-thetac-' num2str(modelNum) kay '.png'])
close all

Yh = human(result.fit.par, true);
bode(Yh, {0.1, 100})
saveas(gcf(), ['plots/delta-thetae-' num2str(modelNum) kay '.png'])
close all
bode(Yh * plant(modelNum), {0.1, 100})
saveas(gcf(), ['plots/theta-thetae-' num2str(modelNum) kay '.png'])
close all
