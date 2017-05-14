function u = get_input(x0,H1,h1,H2,h2,Hu,hu,...
                    N,A,B,Q,R,mid_weight,...
                    ord,test_result)
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
% Q = eye(4);
% R = eye(4);
% mid_weight = 1000;
% ord = 1;
% N=2;
% test_result = true;
% u = get_input(x,H1,h1,H2,h2,Hu,hu,N,A,B,Q,R,mid_weight,ord,test_result)

% Dimension of the state and input
n = size(H1,2);
m = size(Hu,2);

% Create optimization variable
u = sdpvar(N*m,1);

% Create optimization constraints
% State constraints Hx*[x(0);u] <= hx
Hx = zeros(2*(N+1)*n,n+N*m);
hx = [repmat(h1,N,1);h2];

% Input constraints HU*u <= hU
HU = [];
hU = repmat(hu,N,1);

% x(i) = A^(i)x(0) + A^(i-1)Bu(0) + .... Bu(i-1)
% x(i) = ABterm * [x(0); u]
Aterm = A;
ABterm = [eye(n) zeros(n,N*m)];
C = zeros(N*n,N*m);
% Stay inside P1 for N-1 steps and move to P2
for i=1:N
    Hx((i-1)*2*n+1:i*2*n,:) = H1 * ABterm;
    HU = blkdiag(HU,Hu);
    Aterm = A*Aterm;
    ABterm = A*ABterm + [zeros(n,n+(i-1)*m) B zeros(n,(N-i)*m)];
    C((i-1)*n+1:i*n,:) = ABterm(:,n+1:end);
end
Hx(2*N*n+1:end,:) = H2 * ABterm;
HU = [zeros(2*N*m,n) HU];
HN = [Hx;HU];
hn = [hx;hU];
ConstraintN = HN * [x0;u] <= hn;

% Chebychev Center
P2 = Polyhedron(H2,h2);
xc = P2.chebyCenter.x;
xN = ABterm*[x0;u];

% Performance constraints
% C*u = x = [x(1);x(2);...x(N)]
if ord == 1
    epsilon = sdpvar(N*(m+n)+n,1);
    epsilon_x = epsilon(1:N*n);
    epsilon_u = epsilon(N*n+1:N*(m+n));
    epsilon_cheby = epsilon(end-n+1:end);
    Obj = sum(epsilon);
    Constraint = [ConstraintN,...
                      -epsilon_x <= R*C*u <= epsilon_x, ...
                      -epsilon_u <= Q*u <= epsilon_u, ...
       -epsilon_cheby <= mid_weight*(xc-xN) <= epsilon_cheby];
    options = sdpsettings('solver','gurobi');
elseif ord == 2
    disp('Not Implemented');
elseif ord == Inf
    epsilon = sdpvar(3,1);
    epsilon_x = epsilon(1)*ones(N*n,1);
    epsilon_u = epsilon(2)*ones(N*m,1);
    epsilon_cheby = epsilon(3)*ones(n,1);
    Obj = sum(epsilon);
    Constraint = [ConstraintN,...
                -epsilon_x*ones <= R*C*u <= epsilon_x,...
                      -epsilon_u <= Q*u <= epsilon_u,...
           -epsilon_cheby <= mid_weight*(xc-xN) <= epsilon_cheby];
   options = sdpsettings('solver','gurobi');
end

sol = optimize(Constraint, Obj, options);

u = value(u);

% Test
if test_result
    P1 = Polyhedron(H1,h1);
    P2 = Polyhedron(H2,h2);
    Pu = Polyhedron(Hu,hu);
    xp = x0;
    assert(P1.contains(xp));
    for i=1:N-1
        up = u((i-1)*m+1:i*m);
        assert(Pu.contains(up));
        xi = A*xp + B*up;
        assert(P1.contains(xi));
        xp = xi;
    end

    up = u(end-m+1:end);
    assert(Pu.contains(up));
    xi = A*xp + B*up;
    assert(P2.contains(xi));
end
    





