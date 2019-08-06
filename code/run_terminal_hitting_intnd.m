function varargout = run_terminal_hitting_intnd(varargin)
% RUN_INT2D_TERMINAL Run the terminal-hitting time problem for a 2-D integrator.
%
%   RUN_INT2D_TERMINAL Computes the terminal-hitting time probabilities for a
%   2-D integrator.
%
%   RUN_INT2D_TERMINAL parameters:
%
%   TimeHorizon   - Time horizon N for the problem.
%   NumSamples    - Number of samples used to build the approximation.
%   NumTestPoints - Number of test points to evaluate.
%   Sigma         - Bandwidth paramter for the Gaussian kernel function.
%   Lambda        - Regularization paramter to avoid overfitting.

%   Essentially, we want to compute the equation:
%
%   Vk(x) * (K + lambda*m*I)^-1 * K(x, X)

rng(0);

p = inputParser;
addParameter(p, 'TimeHorizon', 3);
addParameter(p, 'Dimensionality', 10000);
addParameter(p, 'NumSamples', 1024);
addParameter(p, 'NumTestPoints', 10201);
addParameter(p, 'Sigma', 0.1);                % Default value determined via cv.
addParameter(p, 'Lambda', 1);                 % Default value determined via cv.
parse(p, varargin{:});

% Time Horizon
%
% We add one to account for zero indexing.
N = p.Results.TimeHorizon + 1;

% Dimensionality
D = p.Results.Dimensionality;

% Number of samples.
m = p.Results.NumSamples;

% Gaussian kernel bandwidth parameter.
sigma = p.Results.Sigma;

% Regularization parameter.
lambda = p.Results.Lambda;

% Number of test points.
mt = p.Results.NumTestPoints;

%% Generate samples %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute input/output samples for the dynamics.
[X, Y] = generate_samples_intnd(m, 'Dimensionality', D);

m = round(sqrt(m))^2;

Xt = generate_samples_intnd(mt, 'Dimensionality', D);

mt = round(sqrt(mt))^2;

%% Start timing the algorithm. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tic

%% Calculate the kernel matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The Gram (kernel) matrix is defined as G_ij = G(x_i, x_j). Here, we use the
% Gaussian kernel with a bandwidth parameter sigma.

G = compute_gram_matrix(X);

%% Compute the weight matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The weight matrix is defined as (K + lambda*m*I)^-1.

W = G + lambda * m * eye(m);

% Here, we wait to invert the matrix to take advantage of Matlab's faster
% inversion using backslash.

%% Compute the value function for the output samples. %%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Here, we compute the value function V_k(x') over the output samples.

Vk = compute_value_functions_intnd(N, X, Y, W);

% Note that the target and safe sets are defined as the space [-1, 1] in all
% dimensions.

%% Compute the beta coefficients. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Beta = compute_beta(X, Xt);
Beta = W\Beta;
Beta = Beta./sum(abs(Beta), 1);

%% Compute the safety probabilities. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pr = zeros(N, mt);

Pr(N, :) = double(all(abs(Xt) <= 1, 1));

in_safe_set = double(all(abs(Xt) <= 1, 1));

for k = N-1:-1:1
  Pr(k, :) = in_safe_set.*(Vk(k+1, :)*Beta);
end

switch nargout
case 1
  varargout{1} = Pr;
case 2
  varargout{1} = Pr;
  varargout{2} = Xt;
end
