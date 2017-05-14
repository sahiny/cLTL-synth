%%
clear; close all; clc;

%% system parameters
M = 100000;
% initial condition
x0 = [0;0];

% system dynamics (x+ = Ax+Bu)
A = eye(2);
B = eye(2);

% state constraints
Hx = [eye(2);-eye(2)];
hx = [10;10;10;10];

% input constraints
Hu = [eye(2);-eye(2)];
hu = 2*[1;1;1;1];

% goal regions
G1 = Polyhedron('lb',[7,7],'ub',[9,9]);
G2 = Polyhedron('lb',[5,7],'ub',[7,9]);
G3 = Polyhedron('lb',[6,1],'ub',[8,3]);


% time horizon
h = 12;

%% optimization problem

% constraints
C = [];

% cost function
F = [];

%% optimization variables

% inputs
u = sdpvar(2, h, 'full');
x = x0;
%x = [0 0; 1.2 1.2; 2.4 2.4; 3.6 3.6;...
%     4.8 4.8; 6 6; 6.2 6.2; 6 7.2; 7.2 6;...
%     7.2 4.8; 7.2 3.6; 7.2 2.4; 7 1.2]';%;;...
%     5.8 0; 4.6 0; 3.4 0; 2.2 1.2; 1 2.4; ...
%     0 2.4; 0 1.2; 0 0]'; 
%%
% signed distances
zg1 = sdpvar(h+1, 1, 'full');
zg2 = sdpvar(h+1, 1, 'full');
zg3 = sdpvar(h+1, 1, 'full');

% spec: F(g1 /\ X(g2)) /\ F(g3)
ztotal = sdpvar(1);

% znext = (g1 /\ X(g2))
znext = sdpvar(h,1,'full');

% eventually goals
    % F(znext)
    zfnext = sdpvar(1);
    C = [C, repmat(zfnext,h,1) >= znext];
    F = F + (10*h)*zfnext;
    % F(g3)
    zfg3 = sdpvar(1);
    C = [C, repmat(zfg3, h+1, 1) >= zg3];
    F = F + (h+1)*zfg3;
% constraints
for i = 1:h
    % Linear Dynamics Constraints (x(i+1) = Ax(i) + Bu(i))
     x = [x, A*x(:,end)+B*u(:,i)];
%     State and Input Constraints
    C = [C, Hx*x(:,i+1) <= hx,  Hu*u(:,i) <= hu];
    %C = [C, B*u(:,i) == x(:,i+1) - A*x(:,i), Hu*u(:,i) <= hu];
    % Signed Distance Constraints
    C = [C, G1.A*x(:,i) + zg1(i)*ones(size(G1.b)) <= G1.b, ...
            G2.A*x(:,i) + zg2(i)*ones(size(G2.b)) <= G2.b, ...
            G3.A*x(:,i) + zg3(i)*ones(size(G3.b)) <= G3.b
            ];
   % Specification Contstaints 
    % znext = (g1 /\ X(g2))
    C = [C, znext(i) <= zg1(i), ...
            znext(i) <= zg2(i+1)];
    F = F - 50*znext(i);
    % zfnext = F(znext)
    C = [C, zfnext >= znext(i)];
    % zfg3 = F(g3)
    C = [C, zfg3 >= zg3(i)];
end
% Last step signed distances
C = [C, G1.A*x(:,i+1) + zg1(i+1)*ones(size(G1.b)) <= G1.b, ...
        G2.A*x(:,i+1) + zg2(i+1)*ones(size(G2.b)) <= G2.b, ...
        G3.A*x(:,i+1) + zg3(i+1)*ones(size(G3.b)) <= G3.b
        ];
 F = -ones(1,h+1)*(zg1+zg2+2*zg3);
 
% ztotal = F(g1 /\ X(g2)) /\ F(g3)
C = [C, ztotal <= zfnext, ztotal <= zfg3, ztotal >= .1];
F = F -ztotal + 20*zfnext + 20*zfg3;

sol = optimize(C,F);
F = value(F);

X = value(x);
U = value(u);
zg1 = value(zg1);
zg2 = value(zg2);
zg3 = value(zg3);
znext = value(znext);
zfnext = value(zfnext);
zfg3 = value(zfg3);
ztotal = value(ztotal);


%% visualize
plot(Polyhedron(Hx,hx), 'color', 'white');
hold on
plot(G1, 'color', 'red');
plot(G2, 'color', 'yellow');
plot(G3, 'color', 'green');
for i = 1:size(X,2)
    plot(X(1,i),X(2,i), '.b')
end
1;
