function [A, B, C, D, K, X0] = structural_model(pars, T, aux)
% function [A, B, C, D, K, X0] = structural_model(pars, T, aux)
%
% Returns the continuous state space description of the structural control
% model.
%
% Parameters
% ----------
% pars : double, size(1,9)
%   The controller parameters.
% T : double
%   The sample time.
% aux : structure
%   aux.plant : integer
%       The number of the plant, either 1, 2, 3, or 4.
%   aux.timeDelay : logical
%       If true a 1st order Pade approximation of the human's time delay is
%       included.
%
% Returns
% -------
% [A, B, C, D, K, X0] : double
%   The state space description. K and X0 are always zeros matrices.

Ys = theta_over_thetac(pars, aux.plant, aux.timeDelay);

[A, B, C, D] = tf2ss(Ys.num{1}, Ys.den{1});

K = zeros(size(A, 1), size(C, 1));

X0 = zeros(size(A, 1), 1);
