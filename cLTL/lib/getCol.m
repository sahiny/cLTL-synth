function fCol = getCol()
% Returns collision avoidence constraints
global Mw;
% number of states
n = length(Mw{1});

% time horizon
k = length(Mw);


fCol = [];
for i = 1:k
    Wi = Mw{i}*ones(n,1);
    fCol = [fCol, Wi<=ones(n,1)];
end

