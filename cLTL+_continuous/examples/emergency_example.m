clear all;
close all;
clc;
addpath(genpath('../'))

global x u Z zLoop ZLoop bigM tau;
bigM = 100;
tau = 0;
% number of robots
N = 10;

% Time horizon
h = 50;

% Initial condition
X0 =[0.5*ones(1,N);
    0.5:1:9.5];

% Collision avoidence flag,
% 1=collision avoidence enforced, 0=no collision avoidence
CA_flag = 1;

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

% visualization
show_env = 0;
if show_env
figure(1);clf;hold on;
plot(Polyhedron(Px.A,Px.b), 'color', 'white');
plot(Polyhedron(ap_A.A,ap_A.b), 'color', 'gray');
plot(Polyhedron(ap_C.A,ap_C.b), 'color', 'gray');
plot(Polyhedron(ap_narrow.A,ap_narrow.b), 'color', 'gray');
plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black');
plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black');
plot(Polyhedron(Obs(3).A,Obs(3).b), 'color', 'black');
plot(Polyhedron(ap_F1.A,ap_F1.b), 'color', 'gray');
hold off
end


% Specs
%not too many robots in narrow passage way
f1 = GG(Neg(TCP(ap_narrow,3))); 

% surveil two regions by leaving them once in a while
f2 = GF(TCP(ap_A, 5)); 
f3 = GF(TCP(ap_C, 5)); 
f4 = GF(Neg(TCP(ap_A, 1))); 
f5 = GF(Neg(TCP(ap_C, 1))); 

% no more than 1 robot is allowed in region E after some time
f6 = FG(Neg(TCP(ap_C, 4))); 

% everyone cross the bridge once in a while
f7 = TCP(GF(ap_F1), 10);

f = And(f1, f2, f3, f4, f5, f6, f7);

% radius of robots (in x-y dimensions)
epsilon = [0.3 0.3]';

[x, u, Z, sol, zLoop] = main_template(f, A, B, Px, Pu, h, X0, Obs, CA_flag, epsilon);

loopBegins = find(zLoop==1);
time = clock;
filename = ['./data/GOBLUE_' ...
num2str(time(1)) '_'... % Returns year as character
num2str(time(2)) '_'... % Returns month as character
num2str(time(3)) '_'... % Returns day as char
num2str(time(4)) 'h'... % returns hour as char..
num2str(time(5)) 'm'... %returns minute as char
];

save(filename);

plot_continuous(x,Z);



