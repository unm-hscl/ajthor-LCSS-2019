function varargout = generate_samples_cwh(n, varargin)
% GENERATE_SAMPLES_CWH_CS Generate n samples for a CWH system.

p = inputParser;
addParameter(p, 'RLim', [0.01, 1.5*sqrt(2)]);
addParameter(p, 'TLim', [3.727, 5.6978]);
addParameter(p, 'dXLim', [-0.00, 0.00]);
addParameter(p, 'dYLim', [-0.00, 0.00]);
addParameter(p, 'ULim', [-0.1, 0.1]);
addParameter(p, 'SampleMode', 'random');
addParameter(p, 'ComputeSamples', false);

parse(p, varargin{:});

rl = p.Results.RLim;
tl = p.Results.TLim;
dxl = p.Results.dXLim;
dyl = p.Results.dYLim;
ul = p.Results.ULim;

M = round(sqrt(n));

% Generate n random points inside the LOS cone.
if strcmp(p.Results.SampleMode, 'uniform')

  t = linspace(tl(1), tl(2), M);
  r = linspace(rl(1), rl(2), numel(t));

  [rr, tt] = meshgrid(r, t);

  x = rr.*cos(tt);
  y = rr.*sin(tt);

  x = reshape(x, 1, []);
  y = reshape(y, 1, []);

else

  t = unifrnd(tl(1), tl(2), [1, n]);
  r = unifrnd(rl(1), rl(2), [1, n]);
  x = r.*cos(t);
  y = r.*sin(t);

end

% Ensure there are samples inside the target set that might lie outside the
% sight cone.
% perm = randperm(M, round(0.05*M));
% x(perm) = unifrnd(-0.1, 0.1, [1, numel(perm)]);
% y(perm) = unifrnd(-0.1, 0.0, [1, numel(perm)]);

dx = unifrnd(dxl(1), dxl(2), size(x));
dy = unifrnd(dyl(1), dyl(2), size(x));

XX = [x;y;dx;dy];

if p.Results.ComputeSamples == false

  % load('samples_cwh.mat');

else

  % Compute the optimal control input.
  srtinit;

  mu = zeros(4, 1);
  Sigma = [ 1E-4  0     0     0   ;
            0     1e-4  0     0   ;
            0     0     5E-8  0   ;
            0     0     0     5E-8];

  sys = getCwhLtiSystem(4, Polyhedron('lb', ul(1)*ones(2,1), ...
                                      'ub', ul(2)*ones(2,1)), ...
                                      RandomVector('Gaussian', mu, Sigma));

  opts = SReachPointOptions('term', 'chance-affine', ...
                            'max_input_viol_prob', 1e-2);


  N = 5;

  ymax = 2;
  vxmax = 0.5;
  vymax = 0.5;
  A_safe_set = [1, 1, 0, 0;
               -1, 1, 0, 0;
                0, -1, 0, 0;
                0, 0, 1,0;
                0, 0,-1,0;
                0, 0, 0,1;
                0, 0, 0,-1];
  b_safe_set = [0; 0; ymax; vxmax; vxmax; vymax; vymax];

  K = Polyhedron(A_safe_set, b_safe_set);

  % Target set --- Box [-0.1,0.1]x[-0.1,0]x[-0.01,0.01]x[-0.01,0.01]
  T = Polyhedron('lb', [-0.1; -0.1; -0.01; -0.01], ...
                 'ub', [ 0.1;    0;  0.01;  0.01]);

  tube = Tube('reach-avoid', K, T, N);

  load('dynamics_cwh.mat');

  X = double.empty(4, 0);
  Y = double.empty(4, 0);

  % Compute the samples and the optimal control actions.
  for k = 1:M^2

    [~, u, ~] = SReachPoint('term', 'chance-affine', sys, XX(:, k), tube, opts);

    if any(isnan(u))
      X = [X, XX(:, k)];
      Ys = A*XX(:, k) + Sigma*randn(4, 1);
      Y = [Y, Ys];
    else
      u = reshape(u, 2, []);
      Ys = XX(:, k);
      for q = 1:N
        % Compute the samples that result from this.
        X = [X, Ys];
        Ys = A*Ys + B*u(:, q) + Sigma*randn(4, 1);
        Y = [Y, Ys];
      end
    end

  end

end

varargout{1} = XX;
% varargout{2} = Y;

end
