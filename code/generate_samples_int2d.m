function varargout = generate_samples_int2d(m, varargin)
% GENERATE_SAMPLES_INT2D Generate samples for a 2-D integrator.
%
%   GENERATE_SAMPLES_INT2D(m) Generates m samples for a 2-D integrator.
%
%   GENERATE_SAMPLES_INT2D parameters:
%
%   SampleVariance      - The variance on the initial condition x_0.
%   DisturbanceVariance - The variance of the disturbance w_0.
%   DisturbanceMatrix   - The real-valued matrix G in the system equations.
%
%   x[k+1] = A*x[k] + G*w[k]

p = inputParser;

validateDisturbance = @(arg) ismember(arg, {'Gaussian', 'Beta', 'Exponential'});

addRequired(p, 'm');
addParameter(p, 'XLim', [-1.1, 1.1]);
addParameter(p, 'YLim', [-1.1, 1.1]);
addParameter(p, 'Disturbance', 'Gaussian', validateDisturbance);
addParameter(p, 'DisturbanceVariance', 0.01);

parse(p, m, varargin{:});

% Disturbance variance.
dv = p.Results.DisturbanceVariance;

xl = p.Results.XLim;
yl = p.Results.YLim;
M = round(sqrt(m));

x = linspace(xl(1), xl(2), M);
y = linspace(yl(1), yl(2), M);
[XX, YY] = meshgrid(x, y);

Xv = reshape(XX, 1, []);
Yv = reshape(YY, 1, []);

X = [Xv; Yv];

varargout{1} = X;

if nargout > 1

  % Load the dynamics.
  load('dynamics_int2d.mat');

  % Preallocate output vector.
  Y = zeros(2, M^2);

  % Create disturbance vector.
  disturbance = p.Results.Disturbance;
  if strcmp(disturbance, 'Gaussian')
    % Gaussian distribution.
    Sigma = dv.*eye(2);
    W = Sigma*randn(2, M^2);

  elseif strcmp(disturbance, 'Beta')
    % Beta distribution.
    alpha = 2;
    beta = 2;
    W = betarnd(alpha, beta, 2, M^2);

  else
    % Exponential distribution.
    W = exprnd(1.5, 2, M^2);

  end

  Y = A*X + G*W;

  varargout{2} = Y;
end
