function plot_cwh(ax, x, y, z)

surf(ax, x, y, z, 'EdgeColor','none', 'LineStyle','none');

v = [-0.1, -0.1; -0.1, 0; 0.1 0; 0.1 -0.1];
f = [1 2 3 4];
patch(ax, 'Faces', f, 'Vertices', v, ...
      'FaceColor', [0 1 0], 'FaceAlpha', 0.25);

v = [-2 -2; 0 0; 2 -2];
f = [1 2 3];
patch(ax, 'Faces', f, 'Vertices', v, ...
      'FaceColor', [1 1 0], 'FaceAlpha', 0.25);

xlim([-2 2]);
ylim([-2 0]);
zlim([0 1]);

caxis([0 1]);
colorbar

view([0, 90]);

end
