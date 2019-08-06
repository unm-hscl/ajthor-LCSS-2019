
cwh = load('results_cwh.mat');

figure
ax = gca;
plot_cwh(ax, cwh.x, cwh.y, cwh.Pr(end-5, :));
