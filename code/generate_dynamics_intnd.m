function generate_dynamics_intnd(varargin)
% GENERATE_DYNAMICS_INTND Generates A, B, G for an N-D integrator system.
%
%   GENERATE_DYNAMICS_INTND() Generates the dynamics for an N-D integrator. This
%   function is run BEFORE anything else, and is not called by any other
%   function.

p = inputParser;
addOptional(p, 'T', 0.25);
addParameter(p, 'Dimensionality', 10000);

parse(p, varargin{:});

% Sampling time.
T = p.Results.T;

% System dimensionality.
D = p.Results.Dimensionality;

sz = (D*(D + 1))/2;

R = zeros([sz, 1]);
C = zeros([sz, 1]);
VAL = zeros([sz, 1]);

k = 1;
for p = 1:D
  for q = p:D
    R(k) = p;
    C(k) = q;

    if p == q
      VAL(k) = 1;
    else
      VAL(k) = (T^(q-p))/factorial(q-p);
    end

    k = k + 1;
  end
end

A = sparse(R, C, VAL);

% Save the state matrix.
save('dynamics_intnd.mat', 'A');
