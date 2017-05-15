function fInit = getInit(W0)
% returns initial state
global W;
% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

for n = 1:N
    current_state = find(W0>0,1);
    W{n}(:,1) = zeros(I,1);
    W{n}(current_state,1) = 1;
    W0(current_state) = W0(current_state) - 1;
end

fInit = [];