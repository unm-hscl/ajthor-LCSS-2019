function run_timed_int2d_dp()
% RUN_TIMED_INT2D Runs 2-D integrator (dynamic programming) for timing purposes.

rng(0);

srtinit;

% X increment.
x_inc = 0.02;
u_inc = 0.1;

% Time Horizon.
N = 3;

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
