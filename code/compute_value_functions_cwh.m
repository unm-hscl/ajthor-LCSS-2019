function varargout = compute_value_functions_cwh(N, X, Y, W, varargin)
% COMPUTE_VALUE_FUNCTIONS_CWH Compute value functions for a CWH system.
%
%   COMPUTE_VALUE_FUNCTIONS_CWH(N, X, Y, W) Computes the value functions for
%   data in X and Y. X is input data, Y is output data. We assume there is no
%   control input (it is already incorporated into the samples) such that
%
%   y ~ Q(.|x)
%
%   COMPUTE_VALUE_FUNCTIONS_CWH parameters:
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
Vk(N, :) = double(abs(Y(1, :)) <= 0.1 & ...
                  -0.1 <= Y(2, :) & Y(2, :) <= 0 & ...
                  abs(Y(3, :)) <= 0.01 & ...
                  abs(Y(4, :)) <= 0.01);

% Compute the value functions for k < N via bacward recursion on Y.
in_safe_set = double(abs(Y(1, :)) <= abs(Y(2, :)) & ...
                     abs(Y(3, :)) <= 0.5 & ...
                     abs(Y(4, :)) <= 0.5);

for k = N-1:-1:1
  Vk(k, :) = in_safe_set.*(Vk(k+1, :)*Beta);
end

varargout{1} = Vk;
