function [fOr,phi] = getOrI(formula,k)

global x Z zLoop ZLoop bigM;
bigM = 1000;
% number of agents
N = length(x);
% time horizon
h = size(x{1},2)-1;

% m*N binvar: a binary variable for each argument and agent 
z = [];

% Constraints
fOr = [];

% number of arguments
if strcmp(formula.type, 'ap')
    formula.args = {formula};
end

m = length(formula.args);

for i=1:m
    if strcmp(formula.args{i}.type, 'inner') % If argument is a formula
        % Get its constraints
        [fAP,phiAP] = getLTL(formula.args{i},k);
        fOr = [fOr, fAP];
        z = [z; phiAP];
    else 
        assert(strcmp(formula.args{i}.type, 'ap'))
        ztemp = getZ(formula.args{i}.formula,h,N);
        A = formula.args{i}.A;
        b = formula.args{i}.b;
        z = [z; ztemp(k,:)];

        for n = 1:N
            xk = x{n}(:,k);
            fOr = [fOr, A*xk <= b + bigM*(1-z(end,n))];
            fOr = [fOr, A*xk >= b - bigM*z(end,n)];
        end
    end
end

if m > 1
    % a binary variable for each agent
    phi = getZ(formula.formula,h,N);
    phi = phi(k,:);
    % conjunction constraint
    for n = 1:N
        fOr = [fOr, repmat(phi(n),m,1)>=z(:,n), phi(n)<=sum(z(:,n))];
    end
else
    phi = z;
end