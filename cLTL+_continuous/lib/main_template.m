function [x, u, Z, sol, zLoop] = main_template(...
    formula, A, B, Px, Pu, h, X0, Obs, CA_flag, epsilon)
% x(t+1) = A*x(t) + B*u(t)
% A = dx*dx matrix
% b = dx*du matrix
% Obs = given as a list of convex polytopes
% X0 = d*N matrix

time = clock;
disp([ 'Started at ', ...
num2str(time(4)), ':',... % Returns year as character
num2str(time(5)), ' on ',... % Returns month as character
num2str(time(3)), '/',... % Returns day as char
num2str(time(2)), '/',... % returns hour as char..
num2str(time(1))]);

assert(h>0, 'Trajectory must be greater than 0');

tos = tic;

global x  u Z zLoop ZLoop bigM;

epsilon = 0.1
% Number of agents
N = size(X0,2);

% bigM notation
bigM = 1000;

% number of states/ inputs
dx = size(A,1);
du = size(B,2);

% states
x = cell(1,N);

% Initial conditions
for n = 1:N
    x{n}(:,1) = X0(:,n);
end
fInit = [];

% Control input u^i(t) = U{i}{t} - vector of dimension du
u = sdpvar(repmat(du,1,N),repmat(h,1,N),'full');

% System dynamics constraint
fDyn = getDyn(A, B, X0, Px, Pu);

% Obstacle Avoidence Constraint
[fObs,zObs] = getObs(Obs, epsilon);

% Loop constraint
fLoop= getLoop();

% Collision Avoidence Constraint ??
if CA_flag
    [fCol, zCol] = getCol(epsilon);
else 
    fCol = [];
end
% Timing of other constraints
toe = toc(tos);
disp(['    Done with other constraints (',num2str(toe),') seconds'])

% LTL constraint
%disp('Creating LTL constraints...')
tltls=tic;
Z = {};
[fLTL,phi] = getLTL(formula,1);
tltle=toc(tltls);
disp(['    Done with LTL constraints (',num2str(tltle),') seconds'])

% All Constraints
F = [fInit, fDyn, fLoop, fCol, fLTL, fObs, phi==1];
%F = [fInit, fDyn, fLoop, fObs];
%F = [fInit, fDyn, fLoop, fObs, x{1}(:,15) == zeros(6,1)];

disp(['    Total number of optimization variables : ', num2str(length(depends(F)))]);

% Solve the optimization problem
%H = -epsilon; % maximize epsilon
options = sdpsettings('verbose',8,'solver','gurobi');
disp('Solving MILP...')
tms=tic;
sol = optimize(F,[],options);
tme=toc(tms);
disp(['    Solved (',num2str(sol.solvertime),') seconds'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assign values


if sol.problem == 0
    % Extract and display value
    disp('## Feasible solution exists ##')
    % Now get the values

    for n = 1:N
       x{n} = value(x{n}); 
       u{n} = value(u{n});
    end
    for i=1:length(Z)
        Z{i}{1} = value(Z{i}{1});
        if ~isnan(Z{i}{1}) 
            1;
        else
            disp(['#### Careful!! ', num2str(Z{i}{2}), ' is NaN']); 
        end
    end
    %Wtotal = value(Wtotal);
    % Loop
    zLoop = value(zLoop);
    ZLoop = value(ZLoop);
    LoopBegins = find(zLoop(:)==1);
else
     W=0;W=0;WT=0;ZLoop=0;zLoop=0;LoopBegins=0;
     display('## No feasible solutions found! ##');
     sol.info
     yalmiperror(sol.problem)
end

ttotal = toc(tos);
mytimes = [ttotal,toe, tltle, sol.solvertime];
yalmip('clear')