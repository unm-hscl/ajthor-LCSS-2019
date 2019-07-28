function varargout = run_terminal_hitting_cwh(varargin)

rng(0);

p = inputParser;
addParameter(p, 'TimeHorizon', 5);
addParameter(p, 'NumSamples', 1024);
addParameter(p, 'NumTestPoints', 10201);
addParameter(p, 'Disturbance', 'Gaussian');
addParameter(p, 'Sigma', 0.1);                % Default value determined via cv.
addParameter(p, 'Lambda', 1);                 % Default value determined via cv.
addParameter(p, 'FileName', './results_cwh.mat');
parse(p, varargin{:});

% Time Horizon
%
% We add one to account for zero indexing.
N = p.Results.TimeHorizon + 1;

% Number of samples.
m = p.Results.NumSamples;

% Gaussian kernel bandwidth parameter.
sigma = p.Results.Sigma;

% Regularization parameter.
lambda = p.Results.Lambda;

% Number of test points.
mt = p.Results.NumTestPoints;

w = p.Results.Disturbance;

%% Generate samples %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute input/output samples for the dynamics.
[X, Y] = generate_samples_cwh(m);
m = round(sqrt(m))^2;

Xt = generate_samples_cwh(mt, 'SampleMode', 'uniform', 'XLim', [-1, 1], 'YLim', [-1, 1]);

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

Vk = compute_value_functions_cwh(N, X, Y, W);

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

x = Xt(1, :);
x = reshape(x, sqrt(length(Xt(1, :))), sqrt(length(Xt(1, :))));
x = x(1, :);
y = x;

switch nargout
case 0
  save(p.Results.FileName, 'x', 'y', 'Pr');
case 1
  varargout{1} = Pr;
case 2
  varargout{1} = Pr;
  varargout{2} = Xt;
end