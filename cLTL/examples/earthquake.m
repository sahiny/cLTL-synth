clear all;close all;clc;

addpath(genpath('.'))

global Mw Z zLoop ZLoop bigM epsilon;

% define a gridworld
grid_size = [10, 10];
mygrid = ones(grid_size);

mygrid(1:5, 1:5) = 0.2;
mygrid(1:5, 6:10) = 0.8;

% narrow passage
mygrid(3, 4:7) = 0.5;
mygrid([1:2,4:5], 5:6) = 0;
mygrid([2,4], [4,7]) = 0;
mygrid([7,8], [7,8]) = 0;

%%%%%%%%%%%

% visualization
vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;
%imshow(kron(vis,ones(25,25)))

state_labels = mygrid(:);

Pass = find(state_labels(:)==0.5)';
pass = num2str(Pass);
Room1 = find(state_labels(:)==0.2)';
room1 = num2str(Room1);
Room2 = find(state_labels(:)==0.8)';
room2 = num2str(Room2);
Room3 = find(state_labels(:)==1)';
room3 = num2str(Room3);

pass_ends = [23,73,Pass];

% spec is the conjunction of the following
Obs = state_labels(:)==0;                   %avoid obstacles
f1 = strcat('G(Neg([',pass,', 2]))');             %not too many robots in narrow passage way

% surveil two regions by leaving them ones in a while
f2 = strcat('GF([',num2str([Room1, 5]),'])');        % GF([0.2 labels, >=5])
f3 = strcat('GF([',num2str([Room2, 5]),'])');        % GF([0.8 labels, >=5])        
f4 = strcat('GF(Neg([',num2str([Room1, 1]),']))');   % GF([0.2 labels, <=0])
f5 = strcat('GF(Neg([',num2str([Room2, 1]),']))');   % GF([0.8 labels, <=0])
f6 = strcat('FG(Neg([',num2str([Room3, 2]),']))');   % FG([1 labels, <=1]) at steady state at most one robot is left in the lower part
f7 = strcat('U(Neg([',num2str([pass_ends,1]),']),And([',num2str([72 74 1]),'],[',num2str([22 24 1]),']))');

%adj = zeros(prod(size(grid)));
adj = eye(numel(mygrid)); %allow self-transition

for i=1:length(state_labels);
    if mod(i, grid_size(1))~=0 
        adj(i, i+1) = 1;
    end
    if mod(i, grid_size(1))~=1
        adj(i, i-1) = 1;
    end
    if i<=grid_size(1)*(grid_size(2)-1);
        adj(i, i+grid_size(1)) = 1;
    end
    if i>grid_size(1);
        adj(i, i-grid_size(1)) = 1;
    end
end

% Total specs
f = strcat('And(',f1,',',f2,',',f3,',',f4,',',f5,',',f6,',',f7,')');

% Adjacency matrix
A = adj;

% Time horizon
h = 40;

% Random initial condition
n = size(A,1);
W0 = [ones(10,1); zeros(n-10,1)];


% robustness number
epsilon = 0;

% Collision avoidence flag,
% 1=collision avoidence enforced, 0=no collision avoidence
CA_flag = 1;

[Mw, WT, Z, ~] = cLTL_synth(f,A,h,W0,Obs,CA_flag);


time = clock;
filename = ['./data/earthquake' ...
num2str(time(1)) '_'... % Returns year as character
num2str(time(2)) '_'... % Returns month as character
num2str(time(3)) '_'... % Returns day as char
num2str(time(4)) 'h'... % returns hour as char..
num2str(time(5)) 'm'... %returns minute as char
];

save(filename);

grid_plot(filename);



