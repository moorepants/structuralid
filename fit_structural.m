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

aux.timeDelay = true;
aux.plant = modelNum;

[A, B, C, D, K, X0] = structural_model(pars(:, modelNum), 0.0005, aux);

mod = idgrey('structural_model', pars(:, modelNum), 'c', aux);
mod.Name = 'Structural Guess';
mod.InputName = dat.InputName;
mod.OutputName = dat.OutputName;
if estimateK
    mod.DisturbanceModel = 'Estimate';
    kay = '-K';
else
    mod.DisturbanceModel = 'Model';
    kay = '';
end

display(sprintf('The order of the closed loop system is %u.', size(mod.A, 1)))
display(sprintf('The gain guesses: k1=%f, k2=%f, k3=%f, k4=%f', mod.par(1:4)))

fit = pem(idDat, mod, ...
          'FixedParameter', 5:9, ...
          'Focus', 'Stability');
fit.Name = 'Structural Best Fit';
uncert = diag(fit.cov(1:4, 1:4));
display(sprintf('The identified gains: k1=%f+\\-%f, k2=%f+\\-%f, k3=%f+\\-%f, k4=%f+\\-%f\n', ...
    fit.par(1), uncert(1), ...
    fit.par(2), uncert(2), ...
    fit.par(3), uncert(3), ...
    fit.par(4), uncert(4)))

% create a plot directory if one doesn't already exist
if exist('plots/', 'dir') ~= 7
    mkdir('plots/')
end

compare(valDat, arxmod, mod, fit)
saveas(gcf(), ['plots/compare-' num2str(modelNum) kay '.png'])
close all

bode(arxmod, 'sd', 1, 'fill', mod, fit, 'sd', 1, 'fill', {0.1, 100})
saveas(gcf(), ['plots/theta-thetac-' num2str(modelNum) kay '.png'])
close all

Yh = human(fit.par, aux.timeDelay);
bode(Yh, {0.1, 100})
saveas(gcf(), ['plots/delta-thetae-' num2str(modelNum) kay '.png'])
close all
bode(Yh * plant(modelNum), {0.1, 100})
saveas(gcf(), ['plots/theta-thetae-' num2str(modelNum) kay '.png'])
close all
