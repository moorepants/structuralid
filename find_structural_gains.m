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
% plantNum : integer or cell array, size(1, 3)
%   The number of the plant type or a matrix containing the first plant
%   number, second plant number, and the percent of the first plant, e.g.
%   [1, 5, 0.4].
% varargin : char value pairs, optional
%   timeDelay : boolean, default=true
%       true if the model should have a time delay.
%   estimateK : boolean, default=true
%       true if the process noise matrix should be estimated.
%   display : boolean, default=true
%       true if the results should be displayed to the terminal.
%   warning : boolean, default=true
%       If false the warnings in the pem estimator will not be shown.
%   randomGuess : boolean, default=false
%       If true, then random initial guesses will be tried based on guess
%       until a stable predictor is found.

parser = inputParser;
parser.addRequired('data');
parser.addRequired('guess');
parser.addRequired('plantNum');
parser.addParamValue('timeDelay', true);
parser.addParamValue('estimateK', true);
parser.addParamValue('display', true);
parser.addParamValue('warning', true);
parser.addParamValue('randomGuess', false);
parser.parse(data, guess, plantNum, varargin{:});
args = parser.Results;

aux.timeDelay = args.timeDelay;
aux.plant = args.plantNum;

mod = idgrey('structural_model', args.guess, 'c', aux);
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

% TODO: Try other initial guesses if the VAF is low to try to avoid local
% minima.
if ~args.warning
    warning off
end
while true
    try
        fit = pem(args.data, mod, ...
                  'FixedParameter', 5:9, ...
                  'Focus', 'Stability');
        break;
    catch err
        if (strcmp(err.identifier, ...
            'Ident:estimation:InvalidInitialModel')) & args.randomGuess
            while true
                try
                    mod = init(mod, [ones(1, 4), zeros(1, 5)], [], 'p');
                    break;
                catch err
                    if (strcmp(err.identifier,'Ident:idmodel:idgreySSDataCheck3'))
                        continue;
                    else
                        rethrow(err);
                    end
                end
            end
            display(sprintf('Trying new guess: k1=%f, k2=%f, k3=%f, k4=%f', mod.par(1:4)))
        else
            rethrow(err);
        end
    end
end
warning on

fit.Name = 'Structural Best Fit';
uncert = diag(fit.cov(1:4, 1:4));

if args.display
    display(sprintf('The identified gains: k1=%f+\\-%f, k2=%f+\\-%f, k3=%f+\\-%f, k4=%f+\\-%f', ...
        fit.par(1), uncert(1), ...
        fit.par(2), uncert(2), ...
        fit.par(3), uncert(3), ...
        fit.par(4), uncert(4)))
end

result.mod = mod;
result.fit = fit;
result.uncert = uncert;
