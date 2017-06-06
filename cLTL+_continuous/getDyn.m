function fDyn = getDyn(A, B, X0, Px, Pu)
% returns dynamical constraints
global u x;

% number of agents
N = length(u);

% time horizon
h = size(u{1},2);

fDyn = [];
for n = 1:N
    x{n} = X0(:,n);
    for t = 1:h
        
        % System dynamics
        xt = x{n}(:,t);
        ut = u{n}(:,t);
        x{n} = [x{n}, A*xt + B*ut];
        
        % State constraints
        fDyn = [fDyn, Px.A*xt <= Px.b];
        
        % Input constraints
        fDyn = [fDyn, Pu.A*ut <= Pu.b];

    end
end


