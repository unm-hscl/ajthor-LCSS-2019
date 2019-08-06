
load('comp_time.mat');
load('abs_error.mat');

%%
figure('Position', [0, 0, 245, 172], 'Units', 'points');

%%
pD = 1000:1000:10000;

D = 100:100:10000;

ax = subplot(2, 1, 1, 'Units', 'points');
ax.Position = [35 110 200 53.62];
plot(ax, D, mean(t));

set(gca,'box','off')

title('');

xlabel('Dimensionality [$n$]', 'Interpreter', 'latex');
ylabel('Time [$s$]', 'Interpreter', 'latex');
xticks([100 2000 4000 6000 8000 10000]);

set(ax, 'FontSize', 8, 'FontName','TimesNewRoman');

%%

% Number of samples.
M = 10:60;
M = M.^2;

ax = subplot(2, 1, 2, 'Units', 'points');
ax.Position = [35 25 200 53.62];

title('');

hold on
plot(ax, M, mean(max_err3));
plot(ax, M, mean(max_err2));
plot(ax, M, mean(max_err1));
hold off

lobj = legend('$k=2$', '$k=1$', '$k=0$');
lobj.Interpreter = 'latex';
xlim([0, 3500]);
% errorbar(M, avg_max_err, min_max_err, max_max_err);
yticks([0.1 0.3 0.5])
xlabel('Number of Samples [$M$]', 'Interpreter', 'latex')
% ax.YLabel.String = '$\vert V_{0}^{\pi}(x) - \bar{V}_{0}^{\pi}(x) \vert$';
ax.YLabel.String = 'Max Abs. Error';
ax.YLabel.Interpreter = 'latex';
% ylabel('Absolute Error', 'Interpreter', 'latex')

% title('Absolute Error [$\vert V_{0}^{\pi}(x) - \overbar{V}_{0}^{\pi}(x) \vert$]', 'Interpreter', 'latex')

set(ax, 'FontSize', 8, 'FontName','TimesNewRoman');

%%

savefig(gcf, './plots/dim_time.fig');
saveas(gcf, './plots/dim_time.eps', 'epsc');
