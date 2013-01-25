data = load_data('jason_adapt.mat')

dataPlantOne = data(1:30 / data.Ts);
dataAdapting = data(30 / data.Ts:60 / data.Ts);
dataPlantTwo = data(60 / data.Ts:end);

% k1, k2, k3, k4, tau, zetanm, wnm, zetafs, wfs
guessPlantOne = [4.85, 1.79, 20, 20, 0.2, 0.707, 10, 0.707, 65];
resultPlantOne = find_structural_gains(dataPlantOne, guessPlantOne, 1);
guessPlantTwo = [3.36, 0.354, 0.2, 20, 0.2, 0.707, 10, 0.707, 65];
resultPlantTwo = find_structural_gains(dataPlantTwo, guessPlantTwo, 5);

% compute the slope and offset for each gain for initial guesses
kP1 = resultPlantOne.fit.par(1:4);
kP2 = resultPlantTwo.fit.par(1:4);
gainSlopeOffset = [30 * eye(4), eye(4); 60 * eye(4), eye(4)] \ [kP1'; kP2'];

aux.pars = guessPlantOne; % this only uses tau through wfs
aux.timeDelay = true;
aux.m = [-1 / 30; 1 / 30];
aux.b = [1; 0];

mod = idnlgrey('adapting_structural_model', [1, 1, 7], gainSlopeOffset, ...
    zeros(7, 1), 'FileArgument', aux);

fit = pem(dataAdapting, mod);

compare(dataAdapting, fit);
