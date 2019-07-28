function varargout = compute_beta(X, Y, varargin)
% COMPUTE_BETA Generate beta vector/matrix.
%
%   COMPUTE_BETA(X) Computes the beta matrix for data in X, and test data Y.
%
%   COMPUTE_BETA parameters:
%
%   X - Data in column format. The vectors should be stored in each column so
%       that for a D-dimensional system, X is [DxM], where M is the number of
%       sample points.
%   Y - Test data in column format. The vectors should be stored in each column
%       so that for a D-dimensional system, Y is [DxT], where T is the number of
%       test points.
%   sigma - Gaussian kernel bandwidth parameter.

p = inputParser;
addParameter(p, 'sigma', 0.1);

parse(p, varargin{:});

M = size(X, 2);
T = size(Y, 2);

Beta = zeros(M, T);

% Compute the norm.
for k = 1:size(X, 1)
  Beta = Beta + (repmat(Y(k, :), [M, 1]) - repmat(X(k, :)', [1, T])).^2;
end

% Compute the Gaussian kernel function.
Beta = exp(-Beta/(2*p.Results.sigma^2));

varargout{1} = Beta;

end
