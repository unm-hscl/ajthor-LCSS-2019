function varargout = run_terminal_hitting_int2d_dp(varargin)

rng(0);

p = inputParser;
addParameter(p, 'TimeHorizon', 3);
addParameter(p, 'FileName', './results_int2d_dp.mat');

parse(p, varargin{:});

srtinit;

% X increment.
x_inc = 0.02;
u_inc = 0.1;

% Time Horizon.
N = p.Results.TimeHorizon;

% Load the dynamics.
load('dynamics_int2d.mat');

% Here, we set the input space to zero.
mu = zeros(2, 1);
Sigma = 0.01*eye(2);

sys = LtiSystem('StateMatrix', A, ...
                'InputMatrix', B, ...
                'InputSpace', Polyhedron('lb', 0, 'ub', 0), ...
                'DisturbanceMatrix', G, ...
                'Disturbance', RandomVector('Gaussian', mu, Sigma));

% The safe set of the system.
K = Polyhedron('lb', [-1, -1], 'ub', [1, 1]);

% The safety tube.
tube = Tube('viability', K, N);

[Pr, Xv] =  SReachDynProg('term', sys, x_inc, u_inc, tube);

x = Xv{1};
y = Xv{2};

switch nargout
case 0
  save(p.Results.FileName, 'x', 'y', 'Pr');
case 1
  varargout{1} = Pr;
case 2
  varargout{1} = Pr;
  varargout{2} = Xt;
end
