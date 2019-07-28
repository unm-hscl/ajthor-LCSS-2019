function run_timed_cwh(X, Y, Xt)
% RUN_TIMED_INT2D Runs CWH for timing purposes.

%% Calculate the kernel matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G = compute_gram_matrix(X);

%% Compute the weight matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W = G + lambda * m * eye(m);

%% Compute the value function for the output samples. %%%%%%%%%%%%%%%%%%%%%%%%%%

Vk = compute_value_functions_cwh(N, X, Y, W);

%% Compute the beta coefficients. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Beta = compute_beta(X, Xt);
Beta = W\Beta;
Beta = Beta./sum(abs(Beta), 1);

%% Compute the safety probabilities. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pr = zeros(N, mt);

Pr(N, :) = double(abs(Xt(1, :)) <= 0.1 & ...
                  -0.1 <= Xt(2, :) & Xt(2, :) <= 0 & ...
                  abs(Xt(3, :)) <= 0.01 & ...
                  abs(Xt(4, :)) <= 0.01);

in_safe_set = double(abs(Xt(1, :)) <= abs(Xt(2, :)) & ...
                     abs(Xt(3, :)) <= 0.5 & ...
                     abs(Xt(4, :)) <= 0.5);;

for k = N-1:-1:1
  Pr(k, :) = in_safe_set.*(Vk(k+1, :)*Beta);
end