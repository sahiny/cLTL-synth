function fLoop= getLoop()
% returns loop constraints
global W bigM zLoop ZLoop tau;
% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1-tau;

% Loop variables
    % zLoop(i)=1 where loop starts
    zLoop = binvar(h,1);
    % ZLoop(i)=1 for all i in loop
    %ZLoop = zLoop;
% Loop constraints
fLoop = sum(zLoop)==1;

for k = 0:tau
    for n = 1:N
        for i = 1+k:h
            fLoop = [fLoop, W{n}(:,h+1+k) <= W{n}(:,i) + bigM*(1-zLoop(i-k))*ones(I,1)];
            fLoop = [fLoop, W{n}(:,h+1+k) >= W{n}(:,i) - bigM*(1-zLoop(i-k))*ones(I,1)];
        end
    end
end
    ZLoop = cumsum(zLoop);

