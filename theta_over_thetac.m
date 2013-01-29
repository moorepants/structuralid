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
%   The numerical values of the controller parameters: k1, k2, k3, k4, tau,
%   zetanm, wnm, zetafs, wfs.
% plantNum : integer or cell array, size(1, 3)
%   The number of the plant type or a matrix containing the first plant
%   number, second plant number, and the percent of the first plant, e.g.
%   [1, 5, 0.4].
% timeDelay : logical
%   If true a 1st order Pade approximation of the human's time delay will be
%   estimated.
%
% Returns
% -------
% Ys : transfer function
%   The closed loop system transfer function.

Yp = human(pars, timeDelay);
if size(plantNum, 2) > 1
    Yc = plant(plantNum{:});
else
    Yc = plant(plantNum);
end
Ys = feedback(Yp * Yc, 1);
