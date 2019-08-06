function run_timed_int2d(X, Y, Xt)
% RUN_TIMED_INT2D Runs 2-D integrator for timing purposes.

%% Calculate the kernel matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G = compute_gram_matrix(X);

%% Compute the weight matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W = G + size(X, 2) * eye(size(X, 2));

%% Compute the value function for the output samples. %%%%%%%%%%%%%%%%%%%%%%%%%%

Vk = compute_value_functions_int2d(4, X, Y, W);

%% Compute the beta coefficients. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Beta = compute_beta(X, Xt);
Beta = W\Beta;
Beta = Beta./sum(abs(Beta), 1);

%% Compute the safety probabilities. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pr = zeros(4, size(Xt, 2));

Pr(4, :) = double(all(abs(Xt) <= 1, 1));

in_safe_set = double(all(abs(Xt) <= 1, 1));

for k = 3:-1:1
  Pr(k, :) = in_safe_set.*(Vk(k+1, :)*Beta);
end
