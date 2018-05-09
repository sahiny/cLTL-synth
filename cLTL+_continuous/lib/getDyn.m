function fDyn = getDyn(A, B, X0, Px, Pu)
% returns dynamical constraints
global u x tau;

% number of agents
N = length(u);

dx = size(x{1},1);

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
        
        if t > 1
        % State constraints
            fDyn = [fDyn, Px.A*xt <= Px.b];
        end
        
        % Input constraints
        fDyn = [fDyn, Pu.A*ut <= Pu.b];

    end
    
    % After loop variables
    x{n} = [x{n} sdpvar(dx,tau)];
    
end

