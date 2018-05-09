function fLoop= getLoop()
% returns loop constraints
global u x bigM zLoop ZLoop tau;

% number of agents
N = length(x);
% number of states
dx = size(x{1},1);
% time horizon
h = size(u{1},2);

% Loop variables
    % zLoop(i)=1 where loop starts
    zLoop = binvar(h,1);
    % ZLoop(i)=1 for all i in loop
    ZLoop = cumsum(zLoop);
% Loop constraints
fLoop = sum(zLoop)==1;

for n = 1:N
    for k = 0:tau
        for t = k+1:h
            fLoop = [fLoop, x{n}(:,h+1+k) <= x{n}(:,t) + bigM*(1-zLoop(t-k))];%*ones(dx,1)];
            fLoop = [fLoop, x{n}(:,h+1+k) >= x{n}(:,t) - bigM*(1-zLoop(t-k))*ones(dx,1)];
        end
    end
end

