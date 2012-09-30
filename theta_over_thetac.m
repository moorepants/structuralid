function Ys = theta_over_thetac(pars, plantNum, timeDelay)

Yp = human(pars, timeDelay);
Yc = plant(plantNum);
Ys = feedback(Yp * Yc, 1);
