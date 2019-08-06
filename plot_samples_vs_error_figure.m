%% Compute error.

% Number of iterations.
n = 5;

% Number of samples.
M = 10:60;
M = M.^2;

Pr_DP3 = run_terminal_hitting_int2d_dp('TimeHorizon', 1);
Pr_DP2 = run_terminal_hitting_int2d_dp('TimeHorizon', 2);
Pr_DP1 = run_terminal_hitting_int2d_dp('TimeHorizon', 3);

Pr_DP3 = reshape(Pr_DP3(1, :), sqrt(length(Pr_DP3(1, :))), sqrt(length(Pr_DP3(1, :))));
Pr_DP2 = reshape(Pr_DP2(1, :), sqrt(length(Pr_DP2(1, :))), sqrt(length(Pr_DP2(1, :))));
Pr_DP1 = reshape(Pr_DP1(1, :), sqrt(length(Pr_DP1(1, :))), sqrt(length(Pr_DP1(1, :))));

%%
max_err3 = zeros(n, length(M));
max_err2 = zeros(n, length(M));
max_err1 = zeros(n, length(M));

for p = 1:numel(M)
  fprintf('Running for samples %d.      ', M(p));
  for q = 1:n
    fprintf('\b\b\b\b\b%5d/%5d', n, N);

    [Pr, Xt] = run_terminal_hitting_int2d('NumSamples', M(p));

    x = Xt(1, :);
    y = Xt(2, :);
    x = reshape(x, sqrt(length(Xt(1, :))), sqrt(length(Xt(1, :))));
    y = reshape(y, sqrt(length(Xt(2, :))), sqrt(length(Xt(2, :))));
    x = x(1, :);
    y = y(:, 1);

    Pr3 = reshape(Pr(3, :), sqrt(length(Pr(3, :))), sqrt(length(Pr(3, :))));
    Pr2 = reshape(Pr(2, :), sqrt(length(Pr(2, :))), sqrt(length(Pr(2, :))));
    Pr1 = reshape(Pr(1, :), sqrt(length(Pr(1, :))), sqrt(length(Pr(1, :))));

    max_err3(q, p) = max(max(abs(Pr3(3:99, 3:99) - Pr_DP3(3:99, 3:99))));
    max_err2(q, p) = max(max(abs(Pr2(3:99, 3:99) - Pr_DP2(3:99, 3:99))));
    max_err1(q, p) = max(max(abs(Pr1(3:99, 3:99) - Pr_DP1(3:99, 3:99))));
  end
  fprintf('\n');

end
fprintf('\n');

%%
save('abs_error.mat', 'M', 'max_err1', 'max_err2', 'max_err3');

% %%
% avg_max_err = sum(max_err1, 1)/numel(n);
% max_max_err = max(max_err1) - avg_max_err;
% min_max_err = min(max_err1) - avg_max_err;
%
% %%
% figure
% errorbar(M, avg_max_err, min_max_err, max_max_err);
