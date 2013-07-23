function generate_plots(plant_num, run_num, estimate_k, validation_data, models)
% function generate_plots(plant_num, run_num, estimate_k, validation_data, models)
%
% Parameters
% ----------
% plant_num : double
%   The number of the plant.
% run_num : double
%   The number of the run for this plant.
% estimate_k : boolean
%   True if the process noise was estimated.
% validation_data : iddata
%   The data to validate the model outputs against.
% models : structure
%   Should contain the ARX model (arxmod) and the results from the grey box
%   fit (result.mod and result.fit).

% create a plot directory if one doesn't already exist
create_directory('plots/')

% create a directory for this plant if one doesn't already exist
plot_directory = sprintf('plots/plant_%0.2d', plant_num);
create_directory(plot_directory)

if estimate_k
    kay = '-K';
else
    kay = '';
end

filename_beg = sprintf('%s/', plot_directory);
filename_end = sprintf('plant-%0.2d-run-%0.2d%s.png', plant_num, run_num, kay);

[y, fit, x0] = compare(validation_data, models.arxmod, ...
    models.result.mod, models.result.fit);

fig = figure('visible','off');
hold on
plot(validation_data.SamplingInstants, validation_data.OutputData, 'k')
plot(y{1}.SamplingInstants, y{1}.OutputData, 'b')
plot(y{2}.SamplingInstants, y{2}.OutputData, 'g')
plot(y{3}.SamplingInstants, y{3}.OutputData, 'r')
hold off
xlabel('Time [s]')
ylabel('$\theta$ [rad]')
leg_labels = {'Measured',
              sprintf('%s %2.2f%%', models.arxmod.Name, fit{1}),
              sprintf('%s %2.2f%%', models.result.mod.Name, fit{2}),
              sprintf('%s %2.2f%%', models.result.fit.Name, fit{3})};
legend(leg_labels)
saveas(gcf(), [filename_beg 'compare-' filename_end])
close all

% TODO : I'd love to have fig = figure('visible', 'off') for the Bode plots
% but Matlab is so stupid that it fucks up the bode plots when this option
% is on. So I have to wait hours while these stupid plot windows pop up on
% my screen and I can't do any other work.

% closed loop response of the entire system
bode(models.arxmod, 'sd', 1, 'fill', models.result.mod, ...
    models.result.fit, 'sd', 1, 'fill', {0.1, 100})
saveas(gcf(), [filename_beg 'theta-thetac-' filename_end])
close all

% the controller: error in theta (pitch) to stick
Yh = human(models.result.fit.par, true);
bode(Yh, {0.1, 100})
saveas(gcf(), [filename_beg 'delta-thetae-' filename_end])
close all

% open loop transfer function (should be like crossover model)
bode(Yh * plant(plant_num), {0.1, 100})
saveas(gcf(), [filename_beg 'theta-thetae-' filename_end])
close all
