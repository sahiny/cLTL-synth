clear;
close all;
clc;

global W Wtotal Z zLoop ZLoop bigM epsilon tau;

% Time horizon
h = 45;
% robustness number
epsilon = 0;
tau = 2;

% define a gridworld
grid_size = [8, 15];
mygrid = ones(grid_size);

mygrid(1:4, 1:5) = 0.8;
mygrid(1:4, 11:15) = 0.6;

% narrow passage
% mygrid(2, 6:8) = 0.4;
% mygrid(3, 8:10) = 0.4;
mygrid(2:3, 6:10) = 0.4;

% Obstacles
mygrid([1,4], 6:10) = 0;
% mygrid([2,4], [4,7]) = 0;
mygrid(6:7, 13:14) = 0;

%%%%%%%%%%%

state_labels = mygrid(:);

Pass = find(state_labels(:)==0.4)';
pass = num2str(Pass);
Room1 = find(state_labels(:)==0.8)';
room1 = num2str(Room1);
Room2 = find(state_labels(:)==0.6)';
room2 = num2str(Room2);
Room3 = find(state_labels(:)==1)';
room3 = num2str(Room3);

% charging station
mygrid(1:2,1:2) = 0.2;
mygrid(1:2,14:15) = 0.2;
mygrid(7:8,1:2) = 0.2;
%mygrid(9:10,9:10) = 0.2;
state_labels = mygrid(:);

CS = find(state_labels(:)==.2)';
CS = num2str(CS);

% visualization
vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;
imshow(kron(vis,ones(25,25)))

pass_ends = [23,73,Pass];

% spec is the conjunction of the following
Obs = state_labels(:)==0;                   %avoid obstacles
f1 = strcat('GG(Neg(TP([',pass,'],[2])))');             %not too many robots in narrow passage way
f1 = strcat('GG(TP([',num2str(setdiff(1:100,Pass)),'],[6]))');             %not too many robots in narrow passage way

% surveil two regions by leaving them once in a while
f2 = strcat('GF(TP([',num2str(Room1),'],[5]))');        % GF([0.2 labels, >=5])
f3 = strcat('GF(TP([',num2str(Room2),'],[5]))');        % GF([0.8 labels, >=5])        
f4 = strcat('GF(Neg(TP([',num2str(Room1),'],[1])))');   % GF([0.2 labels, <=0])
f5 = strcat('GF(Neg(TP([',num2str(Room2),'],[1])))');   % GF([0.8 labels, <=0])
f6 = strcat('FG(Neg(TP([',num2str(Room3),'],[2])))');   % FG([1 labels, <= 1]) at steady state at most one robot is left in the lower part

f4 = strcat('GF(TP([',num2str(setdiff(1:100,Room1)),'],[8]))');   % GF([0.2 labels, <=0])
f5 = strcat('GF(TP([',num2str(setdiff(1:100,Room2)),'],[8]))');   % GF([0.8 labels, <=0])
f6 = strcat('FG(TP([',num2str(setdiff(1:100,Room3)),'],[6]))'); 

%f7 = strcat('U(Neg([',num2str([pass_ends,1]),']),And([',num2str([72 74 1]),'],[',num2str([22 24 1]),']))');
f7 = strcat('TP(GFI([', num2str(CS), ']),[8])');
%adj = zeros(prod(size(grid)));
adj = eye(numel(mygrid)); %allow self-transition

for i=1:length(state_labels)
    if mod(i, grid_size(1))~=0 
        adj(i, i+1) = 1;
    end
    if mod(i, grid_size(1))~=1
        adj(i, i-1) = 1;
    end
    if i<=grid_size(1)*(grid_size(2)-1)
        adj(i, i+grid_size(1)) = 1;
    end
    if i>grid_size(1)
        adj(i, i-grid_size(1)) = 1;
    end
end
%ll = 21:30;
% Total specs
%f = strcat('And(',f1,',',f2,',',f3,',',f4,',',f5,')');
f = strcat('And(',f1,',',f2,',',f3,',',f4,',',f5,',',f6,',',f7,')');
f = strcat('And(',f1,',',f2,',',f3,',',f4,',',f5,',',f7,')');

%f = strcat('And(',f2,',',f3,',',f7,')');
%f = strcat('TP(FGI([', num2str(ll),']),[10])');
% Adjacency matrix
A = adj;



% Random initial condition
n = size(A,1);
W0=zeros(n,1);
for i=1:n
    if ~Obs(i)
        W0(i) = round(rand(1)*0.65);
    end
end
W0 = [ones(4,1); ones(4,1); zeros(n-8,1)];



% Collision avoidence flag,
% 1=collision avoidence enforced, 0=no collision avoidence
CA_flag = 1;

[W, Wtotal, Z, mytimes, sol] = main_template(f,A,h,W0,Obs,CA_flag);


time = clock;
filename = ['./data/GOBLUE_' ...
num2str(h) 'horizon_'...
num2str(tau) 'tau_'...
num2str(time(1)) '_'... % Returns year as character
num2str(time(2)) '_'... % Returns month as character
num2str(time(3)) '_'... % Returns day as char
num2str(time(4)) 'h'... % returns hour as char..
num2str(time(5)) 'm'... %returns minute as char
];

save(filename,'W','W','Wtotal','Wtotal','ZLoop','ZLoop','A','A','mygrid','mygrid', 'Z', 'Z','sol','sol');



grid_plot(filename);



