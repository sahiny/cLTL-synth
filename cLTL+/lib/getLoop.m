function fLoop= getLoop()
% returns loop constraints
global W bigM zLoop ZLoop;
% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

% Loop variables
    % zLoop(i)=1 where loop starts
    zLoop = binvar(h,1);
    % ZLoop(i)=1 for all i in loop
    ZLoop = zLoop;
% Loop constraints
fLoop = sum(zLoop)==1;

for i = 1:h
    for n = 1:N
        fLoop = [fLoop, W{n}(:,h+1) <= W{n}(:,i) + bigM*(1-zLoop(i))*ones(I,1)];
        fLoop = [fLoop, W{n}(:,h+1) >= W{n}(:,i) - bigM*(1-zLoop(i))*ones(I,1)];
    end
    ZLoop(i) = sum(zLoop(1:i));
end

