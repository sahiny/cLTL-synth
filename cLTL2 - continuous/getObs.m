function [fObs,zObs] = getObs(Obs)
% returns collision avoidance constraints
global x bigM;

% number of agents
N = length(x);
% time horizon 
h = size(x{1},2);

% Obstacle avoidance constraints
fObs= [];
zObs = [];
% for each robot
for n = 1:N
    % at each time instance
    for t = 1:h
        xt = x{n}(:,t);
        % for all obstacles
        for p = 1:length(Obs)
            P = Obs(p);
            ZP = binvar(length(P.b),1);
            zObs = [zObs; ZP];
            for r = 1:length(P.b)
                fObs = [fObs, P.A(r,:)*xt >= P.b(r) + 0.01 - bigM*(1-ZP(r))];
            end
            fObs = [fObs, sum(ZP)>=1];
        end
    end
end
