function [fCol, zCol] = getCol2(col_radius)
% returns collision avoidance constraints
global u x;

% number of agents
N = length(u);

% time horizon
h = size(u{1},2);

% dimension of x
dx = size(x{1}(:,1));

% Ax <= b defines a box around x 
A = [eye(dx);eye(dx);-eye(dx);-eye(dx)];

fCol = [];
zCol = [];
for t = 1:h
    for n1 = 1:N-1
        % position of agent n at time t
        xn1 = x{n1}(:,t);
        xn1t = x{n1}(:,t+1);
        
%         % decide min and max rows
%         ztemp = binvar(dx,1);
%         zCol = [zCol; ztemp];
%         for r = 1:dx
%             fCol
%         
%         
        % epsilon ball around xn
        b = [col_radius + xn1; col_radius - xn1;...
             col_radius + xn1; col_radius - xn1;];
        
        %for all agents whose id's greater than n1
        for n2 = n1+1:N
        % position of agent n2 at time t
        xn2 = x{n2}(:,t);
       
        % avoid collision on discrete time instances
        fCol = [fCol, A*xn2 <= b];
        
        % paths should not cross (there doesn't a alpha*xn1 =/= beta*xn2)
        alpha = sdpvar(1,dx);
        beta = sdpvar(1,dx);
        
        fCol = [fCol, alpha*ones(dx,1) == 1, alpha >= zeros(1,dx)];
        fCol = [fCol, beta*ones(dx,1) == 1, beta >= zeros(1,dx)];

        end

    end
end



