function [W, Wtotal, Z, mytimes, sol] = main_template(formula,A,h,W0,Obs,CA_flag)
time = clock;
disp([ 'Started at ', ...
num2str(time(4)), ':',... % Returns year as character
num2str(time(5)), ' on ',... % Returns month as character
num2str(time(3)), '/',... % Returns day as char
num2str(time(2)), '/',... % returns hour as char..
num2str(time(1))]);

if h==0
    disp('Trajectory must be greater than 0');
    assert(h>0);
end

tos = tic;

global W Wtotal Z zLoop ZLoop bigM epsilon tau;

% Number of agents
N = sum(W0);

% bigM notation
bigM = N+1;

% number of states
I = length(A);

% Control input
W = binvar(repmat(I,1,N),repmat(h+1,1,N),'full');

if N == 1
     W = {W};
end


% Initial state constraint
%disp('Creating other constraints...')
fInit = getInit(W0);

% Obstacle Avoidence Constraint
fObs = getObs(Obs);

% System dynamics constraint
fDyn = getDyn(A,CA_flag);

% Loop constraint
fLoop= getLoop();

% Collision Avoidence Constraint
fCol = getCol();

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
%F = [fInit, fDyn, fLoop, fObs, fLTL, phi==1];
F = [fInit, fDyn, fLoop, fLTL, phi==1, fCol];

% if CA_flag
%     F = [F fCol];
% end
disp(['    Total number of optimization variables : ', num2str(length(depends(F)))]);

% Solve the optimization problem
%H = -epsilon; % maximize epsilon
options = sdpsettings('verbose',8,'solver','gurobi');
options.gurobi.Heuristics = 0.3;
options.gurobi.MIPFocus = 1;
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
       W{n} = value(W{n}); 
    end
    for i=1:length(Z)
        Z{i}{1} = value(Z{i}{1});
        if ~isnan(Z{i}{1}) 
            1;
        else
            disp(['#### Careful!! {',num2str(i), '} ', num2str(Z{i}{2}), ' is NaN']); 
        end
    end
    Wtotal = value(Wtotal);
    % Loop
    zLoop = value(zLoop);
    ZLoop = value(ZLoop);
    LoopBegins = find(zLoop(:)==1);
else
     W=0;W=0;WT=0;ZLoop=0;zLoop=0;LoopBegins=0;
     sol.info
     yalmiperror(sol.problem)
     assert(0,'## No feasible solutions found! ##');
end

ttotal = toc(tos);
mytimes = [ttotal,toe, tltle, sol.solvertime];
yalmip('clear')