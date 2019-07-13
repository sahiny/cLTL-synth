function [fAnd,phi] = getAndITau(formula,args,k)

global W Wtotal Z zLoop ZLoop bigM epsilon tau Fnum;

% number of agents
N = length(W);
% time horizon
h = size(W{1},2)-1-tau;

% m*N binvar: a binary variable for each argument and agent 
z = [];

% Constraints
fAnd = [];

% number of arguments
m = length(args);

for i=1:m
    if ischar(args{i}) % If argument is a formula
        % Get its constraints
        [fAP,phiAP] = getLTL(args{i},k);
        fAnd = [fAnd, fAP];
        z = [z; phiAP];
    else % if argument is atomic proposition
        % states
        wi = args{i};
        ztemp = getZ(args{i},h,N);
        z = [z; ztemp(k,:)];
        for n = 1:N
            fAnd = [fAnd, sum(W{n}(wi,k))>=1+epsilon-bigM*(1-z(end,n))];
            fAnd = [fAnd, sum(W{n}(wi,k))<=1-epsilon+bigM*z(end,n)-1];
            Fnum = Fnum + 2;
        end
    end
end

if tau >0

    % a binary variable for each agent
    phi2 = getZ(formula,h,N);
    % Robust version
    phi = getZ(strcat('Robust(', formula, ')'),h,N);
    
    for t=1:tau
       if  
    end
    
    % conjunction constraint
    for n = 1:N
        fAnd = [fAnd, repmat(phi2(k,n),m,1)<=z(:,n), phi2(k,n)>=1-m+sum(z(:,n))];
        fAnd = [fAnd, repmat(phi(k,n),tau,1)<= phi2(k:k+tau,n),...
                    phi(k,n)>= sum(phi2(k:k+tau,n))-tau];
    end

    phi = phi(k,:);

else
    if m > 1
        % a binary variable for each agent
        phi = getZ(formula,h,N);
        phi = phi(k,:);
        % conjunction constraint
        for n = 1:N
            fAnd = [fAnd, repmat(phi(n),m,1)<=z(:,n), phi(n)>=1-m+sum(z(:,n))];
        end
    else
        phi = z;
    end
end