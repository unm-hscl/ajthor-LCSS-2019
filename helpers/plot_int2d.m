function plot_int2d(ax, x, y, z, varargin)
% PLOT_INT2D Plots the double integrator figure.

p = inputParser;
addParameter(p, 'FigureTitle', '(a)');

parse(p, varargin{:});

ft = p.Results.FigureTitle;

if size(z, 1) == 1
  Z = reshape(z(1, :), sqrt(length(z(1, :))), sqrt(length(z(1, :))));
else
  Z = z;
end

ph = surf(ax, x, y, Z);

ph.EdgeColor = 'none';
ph.LineStyle = 'none';

title(ft, 'FontWeight', 'normal');
xlabel('$x_{1}$', 'Interpreter', 'latex')
ylabel('$x_{2}$', 'Interpreter', 'latex')

xlim([-1, 1]);
ylim([-1, 1]);
caxis([0 1]);

colorbar

% view([20, 60]);
view([0, 90]);

set(gca, 'FontSize', 8, 'FontName','Times');

end
