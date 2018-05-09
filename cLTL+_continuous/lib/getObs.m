function [fObs,zObs] = getObs(Obs, col_radius)
% returns collision avoidance constraints
global u x bigM;

% number of agents
N = length(x);
% time horizon 
h = size(u{1},2);

% Obstacle avoidance constraints
fObs= [];
zObs = [];
% for each robot
for n = 1:N
    % at each time instance
    for t = 1:h
        xt = x{n}(:,t);
        xt1 = x{n}(:,t+1);
        % for all obstacles
        for p = 1:length(Obs)
            P = Obs(p);
            ZP = binvar(length(P.b),1);
            zObs = [zObs; ZP];
%             for r = 1:length(P.b)
%                 fObs = [fObs, P.A(r,:)*xt >= P.b(r) + col_radius - bigM*(1-ZP(r))];
%                 fObs = [fObs, P.A(r,:)*xt1 >= P.b(r) + col_radius - bigM*(1-ZP(r))];
%             end
            fObs = [fObs, P.A*xt >= P.b + col_radius*ones(size(P.b)) - bigM*(ones(size(P.b))-ZP)];
            fObs = [fObs, P.A*xt1 >= P.b + col_radius*ones(size(P.b)) - bigM*(ones(size(P.b))-ZP)];
            fObs = [fObs, sum(ZP)>=1];
        end
    end
end
