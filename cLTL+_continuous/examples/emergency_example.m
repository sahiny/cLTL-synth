% clear all;
% close all;
% clc;
% addpath(genpath('../'))
function sol = emergency_example(iN,ih,itau,iCA, X0)
global x u Z zLoop ZLoop bigM tau col_radius;
bigM = 11;
% number of robots
N =iN;
%  addpath(genpath('../'))
% Time horizon
h = ih;

% Time robustness
tau = itau;

% Collision avoidence flag,
% 1=collision avoidence enforced, 0=no collision avoidence
CA_flag = iCA;
% radius of robots
epsilon = 0.2;
col_radius = epsilon;

% X0 =[0.5*ones(1,N);
%     0.5:9/(N-1):9.5];

% system parameters
A = eye(2);
B = eye(2);

% state constraints
Px = Polytope([eye(2); -eye(2)], [10; 10; 0; 0]);

% input constraints
Pu = Polytope([eye(2); -eye(2)], [1; 1; 1; 1]);

% atomic propositions
ap_cell = {};

% narrow passage
[ap_narrow, ap_cell] = AP([eye(2); -eye(2)],[7; 8; -3; -7], ap_cell);

% passage ends
[ap_narrow11, ap_cell] = AP([eye(2); -eye(2)],[3; 9; -2; -8], ap_cell);
[ap_narrow12, ap_cell] = AP([eye(2); -eye(2)],[3; 7; -2; -6], ap_cell);
[ap_narrow21, ap_cell] = AP([eye(2); -eye(2)],[8; 9; -7; -8], ap_cell);
[ap_narrow22, ap_cell] = AP([eye(2); -eye(2)],[8; 7; -7; -6], ap_cell);


% Region A
[ap_A, ap_cell] = AP([eye(2); -eye(2)],[3; 10; 0; -5], ap_cell);

% Region C
[ap_C, ap_cell] = AP([eye(2); -eye(2)],[10; 10; -7; -5], ap_cell);

% Region E
[ap_E, ap_cell] = AP([eye(2); -eye(2)],[10; 5; 0; 0], ap_cell);

% Region F
[ap_F1, ap_cell] = AP([eye(2); -eye(2)],[2; 2; 0; 0], ap_cell);
[ap_F2, ap_cell] = AP([eye(2); -eye(2)],[2; 10; 0; -8], ap_cell);
[ap_F3, ap_cell] = AP([eye(2); -eye(2)],[10; 10; -8; -8], ap_cell);


% Obstacles
Obs1 = Polytope([eye(2); -eye(2)], [8; 3; -6; -1]);
Obs2 = Polytope([eye(2); -eye(2)], [7; 10; -3; -8]);
Obs3 = Polytope([eye(2); -eye(2)], [7; 7; -3; -5]);
Obs = [Obs1, Obs2, Obs3];
%%%%%%%%%%%

% 1;
% X0 = [2.0974    4.5687    8.3774    9.7017;
%     6.7739    2.9488    3.4772    4.0247];
% visualization
if 0
figure(1);clf;hold on;
plot(Polyhedron(Px.A,Px.b), 'color', 'white');
plot(Polyhedron(ap_A.A,ap_A.b), 'color', 'gray');
plot(Polyhedron(ap_C.A,ap_C.b), 'color', 'gray');
plot(Polyhedron(ap_narrow.A,ap_narrow.b), 'color', 'gray');
plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black');
plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black');
plot(Polyhedron(Obs(3).A,Obs(3).b), 'color', 'black');
plot(Polyhedron(ap_F1.A,ap_F1.b), 'color', 'gray');
for i = 1:iN
rectangle('Position', [X0(1,i)-epsilon, X0(2,i)-epsilon 2*epsilon 2*epsilon], 'FaceColor', 'r')
end
hold off
end
% Specs

%not too many robots in narrow passage way
f1 = GG(Neg(TCP(ap_narrow,3))); 

% surveil two regions by leaving them once in a while
f2 = GF(TCP(ap_A, N/2)); 
f3 = GF(TCP(ap_C, N/2)); 

if itau == 0
    f4 = GF(Neg(TCP(ap_A, 1)));
    f5 = GF(Neg(TCP(ap_C, 1))); 
    f8 = U(Neg(TCP(ap_narrow, 1)), And(Or(TCP(ap_narrow11, 1, 1:2:N), TCP(ap_narrow12, 1, 1:2:N)), Or(TCP(ap_narrow21, 1, 1:2:N), TCP(ap_narrow22, 1, 1:2:N))));
else
    f4 = GF(TCP(Or(ap_C, ap_E, ap_narrow), iN)); 
    f5 = GF(TCP(Or(ap_A, ap_E, ap_narrow), iN)); 
    f8 = U(TCP(Or(ap_A, ap_C, ap_E), iN), And(Or(TCP(ap_narrow11, 1, 1:2:N), TCP(ap_narrow12, 1, 1:2:N)), TCP(ap_narrow21, 1, 1:2:N)));
end

% no more than 1 robot is allowed in region E after some time
% f6 = FG(Neg(TCP(ap_C, 4))); 

% everyone charge once in a while
f7 = TCP(GF(Or(ap_F1,ap_F2,ap_F3)), N);
% investigate bridge
% f8 = U(Neg(TCP(ap_narrow, 1)), And(Or(TCP(ap_narrow11, 1), TCP(ap_narrow12, 1)), Or(TCP(ap_narrow21, 1), TCP(ap_narrow22, 1))));


f = And(f1, f2, f3, f4, f5, f7, f8);
%f = And(f1, f2, f3, f4, f5);


[x, u, Z, sol, zLoop] = main_template(f, A, B, Px, Pu, h, X0, Obs, CA_flag, epsilon, tau);

loopBegins = find(zLoop==1);
time = clock;
filename = [strcat('./Journal_data/traces/emergency_continuous_rand' ,...
'N', num2str(N), '_', ...
'h', num2str(h), '_', ...
'tau', num2str(tau), '_', ...
'CA', num2str(CA_flag), '_', ...
num2str(time(1)), '_',... % Returns year as character
num2str(time(2)), '_',... % Returns month as character
num2str(time(3)), '_',... % Returns day as char
num2str(time(4)), 'h',... % returns hour as char..
num2str(time(5)), 'm')... %returns minute as char
];

save(filename);



%plot_continuous(x,Z, zLoop);

    

