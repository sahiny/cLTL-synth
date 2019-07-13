function fCol = getCol()
% returns collision avoidance constraints
global W Wtotal Fnum;
% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1-tau;

Wtotal = W{1};

%fCol = [];
for i = 1:h+1
    for n = 2:N
        Wtotal(:,i) = Wtotal(:,i) + W{n}(:,i);
    end
    %fCol = [fCol, Wtotal(:,i) <= ones(I,1)];
end

fCol = Wtotal(:) <= ones(I*(h+1),1);
Fnum = Fnum + I*(h+1);