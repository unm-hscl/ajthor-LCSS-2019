function generate_dynamics_int2d(varargin)
% GENERATE_DYNAMICS_INT2D Generates A, B, G for a 2-D integrator system.
%
%   GENERATE_DYNAMICS_INT2D() Generates the dynamics for a 2-D integrator. This
%   function is run BEFORE anything else, and is not called by any other
%   function.

p = inputParser;
addOptional(p, 'T', 0.25);

parse(p, varargin{:});

% Sampling time.
T = p.Results.T;

% Generate the state matrix.
A = [1 T; 0 1];
B = [(T^2)/2; T];

G = eye(2);

save('dynamics_int2d.mat', 'A', 'B', 'G');
