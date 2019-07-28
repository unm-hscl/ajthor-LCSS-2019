function varargout = compute_gram_matrix(X, varargin)
% COMPUTE_GRAM_MATRIX Computes the Gram (or kernel) matrix.
%
%   COMPUTE_GRAM_MATRIX(X) Computes the Gram matrix for data in X.
%
%   COMPUTE_GRAM_MATRIX parameters:
%
%   X - Data in column format. The vectors should be stored in each column so
%       that for a D-dimensional system, X is [DxM], where M is the number of
%       sample points.
%   sigma - Gaussian kernel bandwidth parameter.

p = inputParser;
addParameter(p, 'sigma', 0.1);

parse(p, varargin{:});

M = size(X, 2);

G = zeros(M);

% Compute the norm.
for k = 1:size(X, 1)
  G = G + (repmat(X(k, :), [M, 1]) - repmat(X(k, :)', [1, M])).^2;
end

% Compute the Gaussian kernel function.
G = exp(-G/(2*p.Results.sigma^2));

varargout{1} = G;

end
