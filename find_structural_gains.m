function result = find_structural_gains(data, guess, plantNum, varargin)
% function result = find_structural_gains(data, guess, plantNum, varargin)
%
% Returns two structural models: the one with the initial guesses and the
% one with the best fit guesses and the uncertainties in the best fit gains.
%
% Parameters
% ----------
% data : iddata
%   Should contain input thetac and output theta.
% guess : double, size(1, 9)
%   The numerical values of the controller parameters: k1, k2, k3, k4, tau,
%   zetanm, wnm, zetafs, wfs.
% plantNum : double, size(1, 1)
%   A number for the plant type.
% varargin : char value pairs, optional
%   timeDelay : boolean, default=true
%       true if the model should have a time delay.
%   estimateK : boolean, default=true
%       true if the process noise matrix should be estimated.
%   display : boolean, default=true
%       true if the results should be displayed to the terminal.

parser = inputParser;
parser.addRequired('data');
parser.addRequired('guess');
parser.addRequired('plantNum');
parser.addParamValue('timeDelay', true);
parser.addParamValue('estimateK', true);
parser.addParamValue('display', true);
parser.parse(data, guess, plantNum, varargin{:});
args = parser.Results;

aux.timeDelay = args.timeDelay;
aux.plant = args.plantNum;

[A, B, C, D, K, X0] = structural_model(args.guess, args.data.Ts, aux);

mod = idgrey('structural_model', guess, 'c', aux);
mod.Name = 'Structural Guess';
mod.InputName = args.data.InputName;
mod.OutputName = args.data.OutputName;
if args.estimateK
    mod.DisturbanceModel = 'Estimate';
else
    mod.DisturbanceModel = 'Model';
end

if args.display
    display(sprintf('The order of the closed loop system is %u.', size(mod.A, 1)))
    display(sprintf('The gain guesses: k1=%f, k2=%f, k3=%f, k4=%f', mod.par(1:4)))
end

fit = pem(args.data, mod, ...
          'FixedParameter', 5:9, ...
          'Focus', 'Stability');
fit.Name = 'Structural Best Fit';
uncert = diag(fit.cov(1:4, 1:4));

if args.display
    display(sprintf('The identified gains: k1=%f+\\-%f, k2=%f+\\-%f, k3=%f+\\-%f, k4=%f+\\-%f\n', ...
        fit.par(1), uncert(1), ...
        fit.par(2), uncert(2), ...
        fit.par(3), uncert(3), ...
        fit.par(4), uncert(4)))
end

result.mod = mod;
result.fit = fit;
result.uncert = uncert;
