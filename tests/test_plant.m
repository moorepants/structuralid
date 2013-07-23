function test_plant
% this uses the matlab_xunit framework
% add the path to xunit and run "runtests" at the command prompt

addpath('..')

if ~isequal(plant(1), tf(1, [1, 0]))
    error('testPlant:notEqual', 'plant fails');
end

if ~isequal(plant(2), tf(1, [1, 1, 0]))
    error('testPlant:notEqual', 'plant fails');
end

if ~isequal(plant(3), tf(1, [1, 0.2, 0]))
    error('testPlant:notEqual', 'plant fails');
end

if ~isequal(plant(4), tf(10, [1, 10]))
    error('testPlant:notEqual', 'plant fails');
end

if ~isequal(plant(5), tf(5, [1, 10]))
    error('testPlant:notEqual', 'plant fails');
end

if ~isequal(plant(6), tf(10, [1, 0.2, 0]))
    error('testPlant:notEqual', 'plant fails');
end

if ~isequal(plant(1, 2, 0.5), ...
    parallel(0.5 * tf(1, [1, 0]), 0.5 * tf(1, [1, 1, 0])))
    error('testPlant:notEqual', 'plant fails');
end

if ~isequal(plant(1, 5, 0.75), ...
    parallel(0.75 * tf(1, [1, 0]), 0.25 * tf(5, [1, 10])))
    error('testPlant:notEqual', 'plant fails');
end

if ~isequal(plant(4, 6, 0.21), ...
    parallel(0.21 * tf(10, [1, 10]), (1 - 0.21) * tf(10, [1, 0.2, 0])))
    error('testPlant:notEqual', 'plant fails');
end
