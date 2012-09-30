function Yc = plant(num)
% function Yc = plant(num)
%
% Returns the system plant given a number.
%
% Parameters
% ----------
% num : integer, {1, 2, 3}
%   A number between 1 and 3 corresponding to the three plants.
%
% Returns
% -------
% Yc : transfer function
%   1 : 1 / s
%   2 : 1 / s(s + 1)
%   3 : 1 / s(s + 0.2)

if num == 1;
    Yc = tf(1, [1, 0]);
elseif num == 2;
    Yc = tf(1, [1, 1, 0]);
elseif num == 3;
    Yc = tf(1, [1, 0.2, 0]);
end
