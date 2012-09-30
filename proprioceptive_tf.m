function Ypf = proprioceptive_tf(k2, k3)
% function Ypf = proprioceptive_tf(k2, k3)
%
% Parameters
% ----------
% k2 : double
%   The gain.
% k3 : double
%
% Returns
% -------
% Ypf : transfer function
%              k2
%   Ypf(s) = ------
%            s + k3

Ypf = tf(k2, [1, k3]);
