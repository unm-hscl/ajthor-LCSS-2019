D = 100:100:10000;
N = 5;

t = zeros(N, numel(D));

for k = 1:numel(D)
  [X, Y] = generate_samples_intnd(1024, 'Dimensionality', D(k));
%   Xt = generate_samples_intnd(1, 'Dimensionality', D(k));
  Xt = zeros(D(k), 1);

  fprintf('Running for dimensionality %d.      ', D(k));

  for n = 1:N
    fprintf('\b\b\b\b\b%2d/%2d', n, N);

    tic

    %% Calculate the kernel matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    G = compute_gram_matrix(X);

    %% Compute the weight matrix. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    W = G + size(X, 2) * eye(size(X, 2));

    %% Compute the value function for the output samples. %%%%%%%%%%%%%%%%%%%%%%

    Vk = compute_value_functions_intnd(4, X, Y, W);

    %% Compute the beta coefficients. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Beta = compute_beta(X, Xt);
    Beta = W\Beta;
    Beta = Beta./sum(abs(Beta), 1);

    %% Compute the safety probabilities. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Pr = zeros(4, size(Xt, 2));

    Pr(4, :) = double(all(abs(Xt) <= 1, 1));

    in_safe_set = double(all(abs(Xt) <= 1, 1));

    for p = 3:-1:1
      Pr(p, :) = in_safe_set.*(Vk(p+1, :)*Beta);
    end

    t(n, k) = toc;

  end

  fprintf('\n');

end

fprintf('\n');

save('comp_time.mat', 'D', 't');
