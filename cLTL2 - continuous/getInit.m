function fInit = getInit(X0)
% returns initial state
global X;

% number of agents
N = size(X0,2);
% number of states
dx = size(X0,1);
% time horizon
h = size(W{1},2)-1;

% States u^i(t) = U{i}{t} - dx*du matrix
X = cell(N,1);
for n = 1:N
    X{n} = sdpvar(h,dx,'full');
end

fInit = [];