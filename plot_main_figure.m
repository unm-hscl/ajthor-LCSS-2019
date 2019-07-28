function plot_main_figure()
% PLOT_MAIN_FIGURE Plots the main figure.

% To run the code that generates the data, uncomment the following lines:

% run_terminal_hitting_int2d();

% run_terminal_hitting_int2d('NumSamples', 10000, ...
%                             'Disturbance', 'Beta', ...
%                             'FileName', './results_int2d_beta.mat');

% run_terminal_hitting_int2d_dp();

% run_terminal_hitting_cwh();

int2d = load('results_int2d.mat');
int2d_beta = load('results_int2d_beta.mat');
int2d_dp = load('results_int2d_dp.mat');

%%
% fh = figure;
%
% fh.Units = 'points';
% fh.Position = [0, 0, 516, 344];
figure('Units', 'points', ...
        'Position', [0, 0, 516, 172])

%%
ax = subplot(1, 4, 1, 'Units', 'points');
ax.Position = [0 + 30, 25, 95, 137];
plot_int2d(ax, int2d.x, int2d.y, int2d.Pr(1, :));

%%
ax = subplot(1, 4, 2, 'Units', 'points');
ax.Position = [129 + 30, 25, 95, 137];
plot_int2d(ax, int2d_dp.x, int2d_dp.y, int2d_dp.Pr);

%%
ax = subplot(1, 4, 3, 'Units', 'points');
ax.Position = [258 + 30, 25, 95, 137];
plot_int2d(ax, int2d.x, int2d.y, abs(int2d.Pr(1, :) - int2d_dp.Pr));

%%
ax = subplot(1, 4, 4, 'Units', 'points');
ax.Position = [387 + 30, 25, 95, 137];
plot_int2d(ax, int2d.x, int2d.y, int2d_beta.Pr(1, :));

%%
savefig(gcf, './plots/main_figure.fig');
saveas(gcf, './plots/main_figure.eps', 'epsc');
