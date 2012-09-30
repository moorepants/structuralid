function Ys = theta_over_thetac(pars, plantNum, timeDelay)
% function Ys = theta_over_thetac(pars, plantNum, timeDelay)
%
% Returns the closed loop system transfer function.
%
% theta
% ------
% thetac
%
% Parameters
% ----------
% pars : double, size(1, 9)
%   The controller parameters.
% plantNum : integer
%   The number of the plant type.
% timeDelay : logical
%   If true a 1st order Pade approximation of the human's time delay will be
%   estimated.
%
% Returns
% -------
% Ys : transfer function
%   The closed loop system transfer function.

Yp = human(pars, timeDelay);
Yc = plant(plantNum);
Ys = feedback(Yp * Yc, 1);
