function fLoop= getLoop()
% returns loop constraints
global x bigM zLoop ZLoop;

% number of agents
N = length(x);
% number of states
dx = size(x{1},1);
% time horizon
h = size(x{1},2)-1;

% Loop variables
    % zLoop(i)=1 where loop starts
    zLoop = binvar(h,1);
    % ZLoop(i)=1 for all i in loop
    ZLoop = cumsum(zLoop);
% Loop constraints
fLoop = sum(zLoop)==1;

for t = 1:h
    for n = 1:N
        fLoop = [fLoop, x{n}(:,h+1) <= x{n}(:,t) + bigM*(1-zLoop(t))*ones(dx,1)];
        fLoop = [fLoop, x{n}(:,h+1) >= x{n}(:,t) - bigM*(1-zLoop(t))*ones(dx,1)];
    end
end

