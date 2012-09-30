function Ypf = proprioceptive_tf(k2, k3, k4)
% function Ypf = proprioceptive_tf(k2, k3, k4)
%
% Parameters
% ----------
% k2 : double
%   The gain.
% k3 : double
% k4 : double
%
% Returns
% -------
% Ypf : transfer function
%               s + k4
%   Ypf(s) = k2 ------
%               s + k3

Ypf = tf(k2 * [1, k4], [1, k3]);
