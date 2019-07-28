function plot_int2d(ax, x, y, z)

if size(z, 1) == 1
  Z = reshape(z(1, :), sqrt(length(z(1, :))), sqrt(length(z(1, :))));
else
  Z = z;
end

ph = surf(ax, x, y, Z);

ph.EdgeColor = 'none';
ph.LineStyle = 'none';

title('(a)', 'FontWeight', 'normal');
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
