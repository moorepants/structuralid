function [dx, y] = adapting_structural_model(t, x, u, par, aux)
%
% Returns the time derivatives of the states and the output of the
% structural control model with an adapting controller.
%
% Parameters
% ----------
% t : double
%   The current time.
% x : double
%   The current state.
% u : double, size(1, 1)
%   The current input.
% par : double, size(8,1)
%   The slope of the four gains and the offset of the four gains.
% aux : structure
%   pars : double, size(1,9)
%       The controller parameters.
%   timeDelay : logical
%       If true a 1st order Pade approximation of the human's time delay is
%       included.
%   m : double, size(2, 1)
%       The slope of the transfer function adaption function.
%   b : double, size(2, 1)
%       The offset of the transfer function adaption function.
%
% Returns
% -------
% dx : double
%   The derivatives of the states.
% y : double, size(1, 1)
%   The output, theta.

% First compute the gains at this time.
aux.pars(1:4) = m .* t + b;
% Compute the controller.
Yp = human(aux.pars, aux.timeDelay);
% Compute the plant and this time.
c1 = aux.m(1) * t + aux.b(1) + 1e-10;
c2 = aux.m(2) * t + aux.b(2) + 1e-10;
Yc = parallel(c1 * plant(1), c2 * plant(5));
% Compute the closed loop system.
Ys = feedback(Yp * Yc, 1);
% Convert to state space.
[A, B, C, D] = tf2ss(Ys.num{1}, Ys.den{1});
% Compute the derivatives of the states and the outputs.
dx = A * x + B * u;
y = C * x + D * u;
