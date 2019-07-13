function [fCol,zCol] = getColTau(col_radius)
% returns collision avoidance constraints
global u x bigM tau;

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
    for n1 = 1:N
        for k = 0:tau
           % state of agent n1 at time t
           xn1t = x{n1}(:,t+k); 
           % state of agent n1 at time t+1
           xn1t1 = x{n1}(:,t+1+k);
           
           % all other agents should eps-avoid the box around xn1t,x1nt1
           %Nothers = n1+1:N;
           for n2 = n1+1:N
              xn2t = x{n2}(:,t);
              xn2t1 = x{n2}(:,t+1);
              
              ztemp = binvar(2*dx,1);
              zCol = [zCol ztemp];
%               for d = 1:dx
%                   be greater than both
%                   fCol = [fCol, xn2t(d) >= xn1t(d) + 2*col_radius + 0.001 - bigM*ztemp(d)];
%                   fCol = [fCol, xn2t(d) >= xn1t1(d) + 2*col_radius + 0.001 - bigM*ztemp(d)];
%                   or be less than both
%                   fCol = [fCol, xn2t(d) <= xn1t(d) - 2*col_radius - 0.001 + bigM*ztemp(d+dx)];
%                   fCol = [fCol, xn2t(d) <= xn1t1(d) - 2*col_radius - 0.001 + bigM*ztemp(d+dx)];
%                   at least one should be satisfied
%                   fCol = [fCol, sum(ztemp)<=2*dx-1];
%                   same b should work for the next time step as well
%                   fCol = [fCol, xn2t1(d) >= xn1t(d) + 2*col_radius + 0.001 - bigM*ztemp(d)];
%                   fCol = [fCol, xn2t1(d) >= xn1t1(d) + 2*col_radius + 0.001 - bigM*ztemp(d)];
%                   fCol = [fCol, xn2t1(d) <= xn1t(d) - 2*col_radius -0.001 + bigM*ztemp(d+dx)];
%                   fCol = [fCol, xn2t1(d) <= xn1t1(d) - 2*col_radius - 0.001 + bigM*ztemp(d+dx)];
%               end
              % be greater than both
              fCol = [fCol, xn2t >= xn1t + 2*col_radius - bigM*ztemp(1:dx)];
              fCol = [fCol, xn2t >= xn1t1 + 2*col_radius - bigM*ztemp(1:dx)];
              % or be less than both
              fCol = [fCol, xn2t <= xn1t - 2*col_radius + bigM*ztemp(dx+1:end)];
              fCol = [fCol, xn2t <= xn1t1 - 2*col_radius + bigM*ztemp(dx+1:end)];
              % at least one should be satisfied
              fCol = [fCol, sum(ztemp)<=2*dx-1];
              % same b should work for the next time step as well
              fCol = [fCol, xn2t1 >= xn1t + 2*col_radius - bigM*ztemp(1:dx)];
              fCol = [fCol, xn2t1 >= xn1t1 + 2*col_radius - bigM*ztemp(1:dx)];
              fCol = [fCol, xn2t1 <= xn1t - 2*col_radius + bigM*ztemp(dx+1:end)];
              fCol = [fCol, xn2t1 <= xn1t1 - 2*col_radius + bigM*ztemp(dx+1:end)];
           end
        end
    end
end



