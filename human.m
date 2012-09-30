function Yp = human(pars, timeDelay)
% function Yp = human(pars, timeDelay)
%
% Returns the open loop transfer function from the tracking error to the
% human's input.
%
% delta
% ------
% thetae
%
% Parameters
% ----------
% pars : double, size(1, 9)
%   The numerical values of the controller parameters: k1, k2, k3, k4, tau,
%   zetanm, wnm, zetafs, wfs.
% timeDelay : logical
%   If true a first order Pade approximation of a time delay is used.
%
% Returns
% -------
% Yp : transfer function
%   The open loop transfer function which includes all of the controller
%   parameters.

k1 = pars(1);
k2 = pars(2);
k3 = pars(3);
k4 = pars(4);
tau = pars(5);
zetanm = pars(6);
wnm = pars(7);
zetafs = pars(8);
wfs = pars(9);

Ynm = second_order_tf(zetanm, wnm);
Yfs = second_order_tf(zetafs, wfs);
Ypf = proprioceptive_tf(k2, k3, k4);
Yh = feedback(Ynm * Yfs, Ypf);

if timeDelay == true
    [num, den] = pade(tau, 1);
    Ye = k1 * tf(num, den);
else
    Ye = k1;
end

Yp = Ye * Yh;
