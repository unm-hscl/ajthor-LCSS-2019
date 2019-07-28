%% Compute error.

% Number of iterations.
n = 10;

% Number of samples.
M = 10:70;
M = M.^2;

%%
max_err = zeros(n, length(M));
avg_err = zeros(n, length(M));

for p = 1:numel(M)
  fprintf('Calculating for: %d\n', M(p));
  for q = 1:n
    [Pr, Xt] = run_int2d_terminal('TimeHorizon', 3, 'NumSamples', M(p), ...
                                  'NumTestPoints', 10201);

    x = Xt(1, :);
    y = Xt(2, :);
    x = reshape(x, sqrt(length(Xt(1, :))), sqrt(length(Xt(1, :))));
    y = reshape(y, sqrt(length(Xt(2, :))), sqrt(length(Xt(2, :))));
    x = x(1, :);
    y = y(:, 1);

    Pr1 = reshape(Pr(1, :), sqrt(length(Pr(1, :))), sqrt(length(Pr(1, :))));

    max_err(q, p) = max(max(abs(Pr1 - dpba)));
  end
end

%%
avg_max_err = sum(max_err, 1)/numel(n);
max_max_err = max(max_err) - avg_max_err;
min_max_err = min(max_err) - avg_max_err;

%%
figure
errorbar(M, avg_max_err, min_max_err, max_max_err);
