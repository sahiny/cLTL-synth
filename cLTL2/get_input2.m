function u = get_input2(x0,H1,h1,H2,h2,Hu,hu,N,A,B,Q,R,mid_weight,ord)
% finds u such that 
%   f = |Rx|_{ord} + |Qu|_{ord} + mid_weight*|xc - x(N)|_{ord}
% is minimized subject to x(i) \in P1 for i=1,...N-1
%                         x(N) \in P2
%                         u(i) \in Pu
% where P = {x: H*x<=h}
% and xc = Chebychev center of P2
%
% INPUTS
% x = nx1 vector        : initial point
% H1 = kxn matrix       : initial polyhedron H1*x<h1
% h1 = kx1 vector       : initial polyhedron H1*x<h1
% H1 = kxn matrix       : target polyhedron H2*x<h2
% h1 = kx1 vector       : target polyhedron H2*x<h2
% Hu = lxm matrix       : input polyhedron Hu*x<hu
% hu = lx1 vector       : input polyhedron Hu*x<hu
% N = Integer           : Time horizon
% A = nxn matrix        : Dynamics, i.e., x(k+1) = A*x(k) + B*u(k)
% B = nxm matrix        : Dynamics, i.e., x(k+1) = A*x(k) + B*u(k)
% Q = mxm matrix        : Input cost matrix
% R = nxn matrix        : State cost matrix
% mid_weight = Float    : Penalizes the final distance from Chebyshev center
%
%
% OUTPUTS
% u = N*mx1 vector       :Inputs, i.e., u = [u(0)',u(1)',...u(N-1)']'
%
% Example
% x = [0;0];
% H1 = [eye(2);-eye(2)];
% h1 = ones(4,1);
% H2 = [eye(2);-eye(2)];
% h2 = [2; 1; -1; 1];
% Hu = [eye(2);-eye(2)];
% hu = ones(4,1); 
% A = eye(2);
% B = eye(2);
% Q = eye(2);
% R = eye(2);
% mid_weight = 1;
% ord = 2;
% 
% u = get_input(x,H1,h1,H2,h2,Hu,hu,N,A,B,Q,R,mid_weight,ord)

% Dimension of the state and input
n = size(H1,2);
m = size(Hu,2);

% Create optimization variable
u = sdpvar(N*m,1);

% Create optimization constraints
% State constraints 
% Stay inside P1 for N-1 steps and move to P2
% x(i) = A^(i)x(0) + A^(i-1)Bu(0) + .... Bu(i-1) = Aterm*x0 + ABterm * u
Aterm = A;
ABterm = B;
Constraint_x = H1*x0 <= h1;
Constraint_u = [];
for i=1:N-1
    Constraint_x = [Constraint_x, H1*(Aterm*x0 + ABterm*u(1:i*m)) <= h1];
    Constraint_u = [Constraint_u, Hu*u((i-1)*m+1,i*m) <= hu];
    Aterm = A*Aterm;
    ABterm = [A*ABterm B];
end
% Input constraints HU*u <= hU
HU = Hu;
hU = repmat(hu,N);





Hx(2*(N-1)*N:end,:) = H2 * ABterm;
HN = [Hx; zeros(2*N*m,n) HU];

% Performance constraints
% C*u = x = [x(1);x(2);...x(N)]
C = Hx(2*n+1:end,n+1:end);
R = repmat(R,1,N);
Q = repmat(Q,1,N);
if ord == 1
    Obj = ones(1,N*(n+m))
elseif ord == 2
    2;
elseif ord == Inf
    Inf;
end

% Total constraints




