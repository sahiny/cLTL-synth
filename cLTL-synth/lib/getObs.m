function fObs = getObs(Obs,k)

% Returns obstacle avoidance constraints
global Mw Z zLoop ZLoop bigM epsilon;

% number of states
n = length(Obs);

% time horizon
k = length(Mw);

% Obstacle avoidance constraints
fObs=[];
for i = 1:k
    Wi = Mw{i}*ones(n,1);
    fObs = [fObs, Wi(Obs)<=0];
end
