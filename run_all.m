function run_all()
% function run_all()
%
% Runs all of the identifications.

for i = [1:4, 7]
    for j = 0:1
        if j == 0
            kay = 'no';
        elseif j == 1
            kay = 'yes';
        end
        display(sprintf('Plant #%u,  K estimated: %s', i, kay))
        fit_structural(['jason_' num2str(i) '.mat'], j);
    end
end
