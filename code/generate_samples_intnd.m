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

addRequired(p, 'm');
addParameter(p, 'Dimensionality', 10000);
addParameter(p, 'DisturbanceVariance', 0.01);

parse(p, m, varargin{:});

% Dimensionality
D = p.Results.Dimensionality;

% Disturbance variance.
dv = p.Results.DisturbanceVariance;

M = round(sqrt(m));

% Create sample vector.
X = randn(D, m).*0.25;

varargout{1} = X;

if nargout > 1

  % Load the dynamics.
  load('dynamics_intnd.mat');

  A = A(1:D, 1:D);
  G = eye(D);

  % Preallocate output vector.
  Y = zeros(2, M^2);

  % Create disturbance vector.
  W = dv*randn(D, M^2);

  Y = A*X + G*W;

  varargout{2} = Y;
end
