function run_timed_intnd(X, Y, Xt)
% RUN_TIMED_INT2D Runs N-D integrator for timing purposes.

%% Calculate the kernel matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G = compute_gram_matrix(X);

%% Compute the weight matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W = G + lambda * m * eye(m);

%% Compute the value function for the output samples. %%%%%%%%%%%%%%%%%%%%%%%%%%

Vk = compute_value_functions_intnd(N, X, Y, W);

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
