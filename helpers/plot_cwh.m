function plot_cwh(ax, x, y, z, varargin)
% PLOT_CWH Plots the CWH figure.

p = inputParser;
addParameter(p, 'FigureTitle', '(a)');

parse(p, varargin{:});

ft = p.Results.FigureTitle;

n = 1000;
[XX, YY] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));
ph = surf(XX, YY, griddata(x, y, z, XX, YY));

% if size(z, 1) == 1
%   Z = reshape(z(1, :), sqrt(length(z(1, :))), sqrt(length(z(1, :))));
% else
%   Z = z;
% end
%
% ph = surf(ax, x, y, Z);

ph.EdgeColor = 'none';
ph.LineStyle = 'none';

% v = [-0.1, -0.1; -0.1, 0; 0.1 0; 0.1 -0.1];
% f = [1 2 3 4];
% patch(ax, 'Faces', f, 'Vertices', v, ...
%       'FaceColor', [0 1 0], 'FaceAlpha', 0.25);
%
% v = [-2 -2; 0 0; 2 -2];
% f = [1 2 3];
% patch(ax, 'Faces', f, 'Vertices', v, ...
%       'FaceColor', [1 1 0], 'FaceAlpha', 0.25);

title(ft, 'FontWeight', 'normal');

xlim([-1.5 1.5]);
ylim([-1.5 0]);
zlim([0 1]);

xticks([-1.5 0 1.5]);
yticks([0]);

caxis([0 1]);
colorbar

view([0, 90]);

set(gca, 'FontSize', 8, 'FontName','Times');

end
