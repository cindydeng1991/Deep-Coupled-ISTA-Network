function [z] = srOMP_noSI(X_low, Psi_LR, s)

% Solves the problem
%     minimize    ||X_low - Psi_LR * z) ||_2^2                   (1)
%      z_c, z_x
%     subject to  ||z||_0 = s
%
% =========================================================================

z = myOMP(X_low, Psi_LR, s);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Modified OMP function            % 20151029
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w] = myOMP(b, Theta, s)

% 12/12/2015 OMP
% [w] = myOMP(b, Theta, s)
% 
% Orthogonal Matching Pursuit algorithm (OMP) to solve
%
%     minimize    ||b - Theta*w||_2^2                   (1)
%        w
%     subject to  card(w) <= s
%
% where card(.) represents the cardinality of a vector. 
%
% Input:
%   - b: m x 1 vector of observations
%   - Theta: m x n matrix
%   - s: positive integers
%
% Output:
%   - w: (approximate) solution of (1)
% ====================================================================== 
% Check input

[m, n] = size(Theta);

if length(b) ~= m
  error('b should have length equal to the first dimension of Theta')
end

% Initialization

residual   = b;
Omega = [];           % Index of chosen columns
Theta_i      = [];           % List of selected Theta_i 

% Algorithm

w_i = [];
for i = 1 : s

	% Compute the absolute value of inner products and rearrange it in descending order
	inner_product = abs(residual'*Theta);
	[inner_product_ordered, indices_ordered] = sort(inner_product, 'descend');  
	chosen_index = indices_ordered(1);
	Omega = [Omega, chosen_index];          
	Theta_i      = [Theta_i, Theta(:, chosen_index)];
	Theta(:, chosen_index) = zeros(m,1);
	w_i = pinv(Theta_i)*b;     
	residual = b - Theta_i*w_i;

end 
% -------------------------------------------------------------------------------------------------------------------
w = zeros(n,1);
w(Omega) = w_i;
end


