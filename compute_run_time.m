
%% Compute run time for double integrator. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[X, Y] = generate_samples_int2d(1024, 'Disturbance', 'Gaussian');
Xt = generate_samples_int2d(10201, 'XLim', [-1, 1], 'YLim', [-1, 1]);

fprintf('Running double integrator...\n');
tic
run_timed_int2d(X, Y, Xt);
toc

%% Compute run time for double integrator (DP). %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Running double integrator (dynamic programming)...\n');
tic
run_timed_int2d_dp();
toc

%% Compute run time for CWH. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cwh_samples = load('samples_cwh.mat');
Xt = generate_samples_cwh(10201, 'SampleMode', 'uniform', ...
                          'TLim', [5*pi/4, 7*pi/4]);

fprintf('Running cwh...\n');
tic
run_timed_cwh(cwh_samples.X, cwh_samples.Y, Xt);
toc

%% Compute run time for N-D integrator. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[X, Y] = generate_samples_intnd(1024, 'Dimensionality', 10000);
Xt = generate_samples_intnd(1, 'Dimensionality', 10000);

fprintf('Running 10000-D integrator...\n');
tic
run_timed_intnd(X, Y, Xt);
toc

%% Compute chance-constrained open. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

slice_at_vx_vy = zeros(2,1);
init_safe_set_affine = Polyhedron('He',[zeros(2,2) eye(2,2) slice_at_vx_vy]);
n_dir_vecs = 40;
theta_vec = linspace(0, 2*pi, n_dir_vecs);
set_of_dir_vecs_cc_open = [cos(theta_vec);
                           sin(theta_vec)];

cc_options = SReachSetOptions('term', 'chance-open', ...
        'set_of_dir_vecs', set_of_dir_vecs_cc_open, ...
        'init_safe_set_affine', K, ...
        'verbose', 1);
tic
[polytope_cc_open, extra_info] = SReachSet('term','chance-open', sys, ...
    0.8, tube, cc_options);
toc
