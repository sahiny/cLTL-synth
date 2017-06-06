function [fCol,zCol] = getCol(col_radius)
% returns collision avoidance constraints
global u x bigM;

% number of agents
N = length(u);

% time horizon
h = size(u{1},2);

% dimension of x
dx = size(x{1},1);

% Ax <= b defines a box around x 
A = [eye(dx);-eye(dx)];

fCol = [];
zCol = [];
for t = 1:h
    for n1 = 1:N-1
        % position of agent n at time t
        xn1 = x{n1}(:,t);
        % epsilon ball around xn
        b = [2*col_radius + xn1; 2*col_radius - xn1];
        
        %for all agents whose id's less than n1
        for n2 = n1+1:N
        % position of agent n2 at time t
        xn2 = x{n2}(:,t);
        
        ztemp = binvar(length(b),1);
        zCol = [zCol; ztemp];
        for r = 1:length(b)
            fCol = [fCol, A(r,:)*xn2 >= b(r) + 0.01 - bigM*(1-ztemp(r))];
        end
        
        fCol = [fCol, sum(ztemp)>=1];

        end

    end
end



