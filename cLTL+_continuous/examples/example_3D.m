clear all;
close all;
clc;
addpath(genpath('../'))

global x u Z zLoop ZLoop bigM epsilon;
bigM = 1000;
% number of robots
N = 5;

% Time horizon
h = 40;

% Initial condition
X0 =[0.5*ones(1,N);
    0.5:9/(N-1):9.5;
    zeros(1,N)];

% Collision avoidence flag,
% 1=collision avoidence enforced, 0=no collision avoidence
CA_flag = 0;

% system parameters
A = eye(3);
B = eye(3);

% state constraints
Px = Polytope([eye(3); -eye(3)], [10; 10; 10; 10; 10; 0]);

% input constraints
Pu = Polytope([eye(3); -eye(3)], [1; 1; 1; 1; 1; 1]);

% atomic propositions
ap_cell = {};

% ap1
[ap1, ap_cell] = AP([eye(3); -eye(3)],[-7; 1; 5; 9; 1; -3], ap_cell);
[ap2, ap_cell] = AP([eye(3); -eye(3)],[ 1; 1; 5; 1; 1; -3], ap_cell);
[ap3, ap_cell] = AP([eye(3); -eye(3)],[ 9; 1; 5; -7; 1; -3], ap_cell);


% Obstacles
Obs1 = Polytope([eye(3); -eye(3)], [-4; 7; 7; 6; 7; -3]);
Obs2 = Polytope([eye(3); -eye(3)], [ 6; 7; 7; -4; 7; -3]);
Obs = [Obs1, Obs2];
%%%%%%%%%%%

% visualization
if 1
figure(1);clf;hold on;
plot(Polyhedron(Px.A,Px.b), 'color', 'white', 'alpha', 0.1);
plot(Polyhedron(ap1.A,ap1.b), 'color', 'green', 'alpha', 0.1);
plot(Polyhedron(ap2.A,ap2.b), 'color', 'green', 'alpha', 0.1);
plot(Polyhedron(ap3.A,ap3.b), 'color', 'green', 'alpha', 0.1);
plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black', 'alpha', 0.1);
plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black', 'alpha', 0.1);
hold off
end
% Specs

% surveil two regions by leaving them once in a while
f1 = GF(TCP(ap1, 5)); 
f2 = GF(TCP(ap2, 5)); 
f3 = GF(TCP(ap3, 5)); 
%f = And(f1, f2, f3, f4, f5, f7);
f = And(f1,f2, f3);



[x, u, Z, sol, zLoop] = main_template(f, A, B, Px, Pu, h, X0, Obs, CA_flag);

loopBegins = find(zLoop==1);
% time = clock;
% filename = ['./data/GOBLUE_' ...
% num2str(time(1)) '_'... % Returns year as character
% num2str(time(2)) '_'... % Returns month as character
% num2str(time(3)) '_'... % Returns day as char
% num2str(time(4)) 'h'... % returns hour as char..
% num2str(time(5)) 'm'... %returns minute as char
% ];
% 
% save(filename,'W','W','Wtotal','Wtotal','ZLoop','ZLoop','A','A','mygrid','mygrid', 'Z', 'Z','sol','sol');



plot_continuous_3D(x,Z);



