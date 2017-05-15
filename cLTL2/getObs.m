function fObs = getObs(Obs,k)
% returns collision avoidance constraints
global W Wtotal;

% fObs = Wtotal(Obs,:) == 0;

% number of agents
N = length(W);

% Obstacle avoidance constraints
fObs= [];
for n = 1:N
    W{n}(Obs,:) = 0;
    %fObs = [fObs, W{n}(Obs,:) == 0];
end
