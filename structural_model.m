function [A, B, C, D, K, X0] = structural_model(pars, T, aux)

Ys = theta_over_thetac(pars, aux.plant, aux.timeDelay);

[A, B, C, D] = tf2ss(Ys.num{1}, Ys.den{1});

K = zeros(size(A, 1), size(C, 1));

X0 = zeros(size(A, 1), 1);
