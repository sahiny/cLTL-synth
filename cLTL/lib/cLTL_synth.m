function [Mw, WT, Z, mytimes] = cLTL_synth(formula,A,h,W0,Obs,CA_flag)

tos = tic;

global Mw Z zLoop ZLoop bigM epsilon;

% bigM notation
bigM = sum(W0)+1;

% number of states
I = length(A);

% Indices of 0's of adjacency matrix
A0 = find(A==0);
A1 = A(:)==1;
% Control input
Mw = intvar(repmat(I,1,h),repmat(I,1,h),'full');

if h==0
    disp('Trajectory must be greater than 0');
    assert(h>0);
elseif h==1
     Mw = {Mw};
end

for i = 1:h
        Mw{i}(A0) = 0;
end
% Initial state constraint
disp('Creating other constraints...')
fInit = [Mw{1}*ones(I,1)==W0, Mw{1}(A1)>=0];

% System dynamics constraint
fDyn = getDyn(A,h);

% Loop constraint
fLoop= getLoop(h);

% Collision Avoidence Constraint
fCol = getCol();

% Obstacle Avoidence Constraint
fObs = getObs(Obs,h);

% Timing of other constraints
toe = toc(tos);
disp(['    Done with other constraints (',num2str(toe),') seconds'])

% LTL constraint
disp('Creating LTL constraints...')
tltls=tic;
Z = {};
[fLTL,phi] = getLTL(formula,1);
tltle=toc(tltls);
disp(['    Done with LTL constraints (',num2str(tltle),') seconds'])
disp(['    Number of LTL variables                : ', num2str(length(Z))]);

% All Constraints
F = [fInit, fDyn, fLoop, fLTL, fObs, phi==1];

if CA_flag
    F = [F fCol];
end
disp(['    Number of constraints                  : ', num2str(length(F))]);
disp(['    Total number of optimization variables : ', num2str(length(depends(F)))]);

% Solve the optimization problem
%H = -epsilon; % maximize epsilon
options = sdpsettings('verbose',0,'solver','gurobi');
disp('Solving MILP...')
tms=tic;
sol = optimize(F,[],options);
tme=toc(tms);
disp(['    Solved (',num2str(tme),') seconds'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assign values


if sol.problem == 0
 % Extract and display value
disp('## Feasible solution exists ##')
% Now get the values
MW = reshape([Mw{:}],I*I*h,1);
vMW = value(MW);
Mw=cell(h,1);
% Trajectory
W = cell(h+1,1);
WT = zeros(I,h+1);
% % epsilon
% epsilon = value(epsilon);
for i = 1:h
    Mwi = reshape(vMW((i-1)*I*I+1:i*I*I),I,I);
    Mw{i}=Mwi;
    W{i} = Mwi * ones(I,1);
    WT(:,i) = Mwi * ones(I,1);
end
W{h+1} = transpose(ones(1,I)*Mwi);
WT(:,h+1) = ones(1,I)*Mwi;

% Loop
zLoop = value(zLoop);
ZLoop = value(ZLoop);
LoopBegins = find(zLoop(:)==1);
else
 W=0;Mw=0;WT=0;ZLoop=0;zLoop=0;LoopBegins=0;
 display('## No feasible solutions found! ##');
 %sol.info
%  yalmiperror(sol.problem)
end

zz = [];
for i=1:length(Z)
Z{i}{1} = value(Z{i}{1});
if isnan(Z{i}{1}) 
   disp(['#### Careful!! ', num2str(Z{i}{2}), ' is NaN']); 
end
zz = [zz;Z{i}{1}];
end

ttotal = toc(tos);
mytimes = [ttotal,toe, tltle, tme];
yalmip('clear')