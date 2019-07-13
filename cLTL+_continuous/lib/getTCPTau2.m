function [fTCP,phi] = getTCPTau2(formula, k)

global u x Z zLoop ZLoop bigM tau;

assert(strcmp(formula.Op, 'TCP'), 'tcp required');

% number of agents
N = length(x);
% time horizon
h = size(u{1},2);

if isempty(formula.S)
    formula.S = 1:N;
end

S = formula.S;

if k==1 || tau ==0
    [fTCP, r] = getLTL(formula.phi, k, S);
elseif strcmp(formula.phi.Op, 'GF') || strcmp(formula.phi.Op, 'FG')
    r = getZ(formula.phi, 1, N);
else
    % robust tcp
    r = getZ(strcat('Robust( ', formula.formula, ')'), k, N);
    [fTCP, zTilde] = getLTL(formula.phi, k, S);

    for t = 1:tau
        if t+k <= h
            % If t+k <= h no need to loop around
            ztilde = getZ(formula.phi.formula, t+k, N);
            zTilde = [zTilde; ztilde];
        else
            if isempty(find(strcmp([Z{:}],...
                    strcat(formula.phi.formula, '[', num2str(t+k), ']'))))
                [fLTL, ztilde] = getLTL(formula.phi, t+k, S);
                zTilde = [zTilde; ztilde];
                fTCP = [fTCP fLTL];
            else
                ztilde = getZ(formula.phi.formula, t+k, N);
                zTilde = [zTilde; ztilde];
            end
        end
    end
    
    % robustified version
    %r = getZ(strcat('Robust( ', formula, ')'), h, N);
    for n = S
        fTCP = [fTCP, repmat(r(n),tau+1,1)<= zTilde(:,n), r(n) >= sum(zTilde(:,n))-tau];
    end
end
    
phi = getZ(formula.formula,k,1);

fTCP = [fTCP, sum(r(S)) >= formula.m - (N+1)*(1-phi)];
fTCP = [fTCP, sum(r(S)) <= formula.m + (N+1)*phi-1];
