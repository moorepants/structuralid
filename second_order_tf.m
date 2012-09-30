function G = second_order_tf(zeta, omega)
% function G = second_order_tf(zeta, omega)
%
% Returns a simple second order SISO system.
%
% Parameters
% ----------
% zeta : double
%   The damping ratio.
% omega : double
%   The natural frequency.
%
% Returns
% -------
% G : transfer function
%   A second order SISO transfer function of the form:
%
%                       omega^2
%    G(s) = --------------------------------
%           s^2 + 2 * zeta * omega + omega^2

G = tf(omega^2, [1, 2 * zeta * omega, omega^2]);
