function varargout = compute_value_functions_intnd(N, X, Y, W, varargin)
% COMPUTE_VALUE_FUNCTIONS_INTND Generate value functions for a N-D integrator.
%
%   COMPUTE_VALUE_FUNCTIONS_INTND(N, X, Y, W) Computes the value functions for
%   data in X and Y. X is input data, Y is output data. We assume there is no
%   control input (it is already incorporated into the samples) such that
%
%   y ~ Q(.|x)
%
%   COMPUTE_VALUE_FUNCTIONS_INTND parameters:
%
%   X - Input data in column format. The vectors should be stored in each column
%   so that for a D-dimensional system, X is [DxM], where M is the number of
%   sample points.
%   Y - Output data in column format. The vectors should be stored in each
%   column so that for a D-dimensional system, Y is [DxM], where M is the number
%   of sample points.
%   W - The (non-inverted) weight matrix.

m = size(X, 2);
Vk = zeros(N, m);

Beta = compute_beta(X, Y, varargin{:});
Beta = W\Beta;
Beta = Beta./sum(abs(Beta), 1);

% Compute the terminal value function on Y.
Vk(N, :) = double(all(abs(X) <= 1, 1));

% Compute the value functions for k < N via bacward recursion on Y.
in_safe_set = double(all(abs(X) <= 1, 1));

for k = N-1:-1:1
  Vk(k, :) = in_safe_set.*(Vk(k+1, :)*Beta);
end

varargout{1} = Vk;
