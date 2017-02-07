function fInt = getInt(Mw,k,bigM,A)
% Returns integer constraints

% number of states
n = length(A);

% time horizon
k = length(Mw);

% vectorize Mw
MW = reshape([Mw{:}],n*n*k,1);

% Integer constraint
fInt = [integer(MW(:))];