function [z_c, z_x, z_y, varargout] = srOMP_noA(X_low, Y, Psi_cxLR, Psi_xLR, Psi_cy, Psi_y, s)
% [z_c, z_x, z_y] = srOMP(X_low, Y, A, Psi_cx, Psi_x, Psi_cy, Psi_y)
%
% Solves the unmixing problem
%
%      minimize        ||X_low - A*(Psi_cx * z_c + Psi_x * z_x) ||_2^2 
%	z_c, z_x, z_y		+ ||Y - ( Psi_cy * zc + Psi_y * z_y) ||_2^2     
%   
%      subject to		||z_c||_0 + ||z_x||_0 + ||z_y||_0 <= s
%						


% =========================================================================
% Check for errors
Psi_cx_low = Psi_cxLR;
Psi_x_low = Psi_xLR;

[m1, n1] = size(Psi_cx_low);
[m2, n2] = size(Psi_x_low);
[m3, n3] = size(Psi_cy);
[m4, n4] = size(Psi_y);

if m2 ~= m1 || m4 ~= m3 || n3 ~= n1 || length(X_low) + length(Y)  ~= m1 + m3
    error('Dimensions are inconsistent')
end
% =========================================================================
y = [X_low; Y];

A = [Psi_cx_low, Psi_x_low, zeros(m1, n4); ...
    Psi_cy, zeros(m3, n2), Psi_y];

x = myOMP(y, A, s);

z_c = x(1 : n1);
z_x = x(n1 + 1 : n1 + n2);
z_y  = x(n1 + n2 + 1 : n1 + n2 + n3); 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            myOMP function            % 20151029
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

