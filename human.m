function Yp = human(pars, timeDelay)
% delta
% ------
% thetae

k1 = pars(1);
k2 = pars(2);
k3 = pars(3);
tau = pars(4);
zetanm = pars(5);
wnm = pars(6);
zetafs = pars(7);
wfs = pars(8);

Ynm = second_order_tf(zetanm, wnm);
Yfs = second_order_tf(zetafs, wfs);
Ypf = proprioceptive_tf(k2, k3);
Yh = feedback(Ynm * Yfs, Ypf);

if timeDelay == true
    [num, den] = pade(tau, 1);
    Ye = k1 * tf(num, den);
else
    Ye = k1;
end

Yp = Ye * Yh;
