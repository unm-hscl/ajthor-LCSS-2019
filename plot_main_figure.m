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
int2d_dp = load('results_int2d_dp.mat');
int2d_beta = load('results_int2d_beta.mat');
cwh = load('results_cwh.mat');

%%
figure('Units', 'points', ...
       'Position', [0, 0, 245, 172])

ax1 = subplot(1, 2, 1, 'Units', 'points');
plot_int2d(ax1, int2d.x, int2d.y, int2d.Pr(1, :), ...
           'FigureTitle', '(a)');

colorbar(ax1, 'off');
ax1.Position = [30, 25, 80, 137];
ax1.XLabel.Visible = 'off';

ax2 = subplot(1, 2, 2, 'Units', 'points');
plot_int2d(ax2, int2d.x, int2d.y, abs(int2d.Pr(1, :) - int2d_dp.Pr), ...
           'FigureTitle', '(b)');

ax2.YAxis.Visible = 'off';
ax2.Position = [129, 25, 80, 137];
ax2.XLabel.Visible = 'off';

ax3 = axes('Visible', 'off');
ax3.Units = 'points';
ax3.Position = [30 25 179 137];

ax3.XLabel.String = '$x_{1}$';
ax3.XLabel.Interpreter = 'latex';
ax3.XLabel.Visible = 'on';
set(gca, 'FontSize', 8, 'FontName','TimesNewRoman');

savefig(gcf, './plots/main_figure_1.fig');
saveas(gcf, './plots/main_figure_1.eps', 'epsc');

%%
figure('Units', 'points', ...
       'Position', [0, 0, 245, 172])

ax1 = subplot(1, 2, 1, 'Units', 'points');
plot_int2d(ax1, int2d.x, int2d.y, int2d_beta.Pr(3, :), ...
           'FigureTitle', '(a)');

colorbar(ax1, 'off');
ax1.Position = [30, 25, 80, 137];
set(ax1, 'FontSize', 8, 'FontName','Times');
% ax1.XLabel.Visible = 'off';

ax2 = subplot(1, 2, 2, 'Units', 'points');
plot_cwh(ax2, cwh.x, cwh.y, cwh.Pr(end-5, :), 'FigureTitle', '(b)');
% plot_int2d(ax2, int2d.x, int2d.y, abs(int2d.Pr(1, :) - int2d_dp.Pr), ...
           % 'FigureTitle', '(b)');

% ax2.YAxis.Visible = 'off';
ax2.Position = [129, 25, 80, 137];
ax2.XLabel.Interpreter = 'latex';
ax2.XLabel.String = '$z_{1}$';
ax2.YLabel.Interpreter = 'latex';
ax2.YLabel.String = '$z_{2}$';
set(ax2, 'FontSize', 8, 'FontName','Times');
% ax2.XLabel.Visible = 'off';

% ax3 = axes('Visible', 'off');
% ax3.Units = 'points';
% ax3.Position = [30 25 184 137];
% 
% ax3.XLabel.String = '$x_{1}$';
% ax3.XLabel.Interpreter = 'latex';
% ax3.XLabel.Visible = 'on';
% set(gca, 'FontSize', 8, 'FontName','Times');

savefig(gcf, './plots/main_figure_2.fig');
saveas(gcf, './plots/main_figure_2.eps', 'epsc');
