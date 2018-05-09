function [fTCP,phi] = getTCPTau(formula, k)

global u x Z zLoop ZLoop bigM tau;

assert(strcmp(formula.Op, 'TCP'), 'tcp required');

% number of agents
N = length(x);
% time horizon
h = size(u{1},2)-tau;


if k==1 || tau ==0
    [fTCP, r] = getLTL(formula.phi, k);
else
    % robust tcp
    r = getZ(strcat('Robust( ', formula.formula, ')'), k, N);
    [fTCP, zTilde] = getLTL(formula.phi, k);

    for t = 1:tau
        if t+k <= h+tau
            % If t+k <= h no need to loop around
            ztilde = getZ(formula.phi.formula, t+k, N);
            zTilde = [zTilde; ztilde];
        else
           
            % ztilde_{k+t} (one for each agent)
            ztilde = getZ(strcat('~(',formula.phi.formula,')'),t+k,N);
            % Add to all set of all ztilde
            zTilde = [zTilde; ztilde];
            % Or(z^{args{1},n}_{l+k+t-h-1},1-zLoop_{l})
            ZOr = [];
            for l = 1:h-t
                 % Loop around
                % z^{\args{1},n}_t for all t,n
                zPhi = getZ(formula.phi.formula, l+t+k-h-1, N);
                % Or(z^{args{1},n}_{l+k+t-h-1},1-zLoop_{l})
                zOr = getZ(strcat('Or(',formula.phi.formula,...
                ', Neg(zLoop))[',num2str(k),',',num2str(t),']'),l,N);
                ZOr = [ZOr; zOr];
                for n = 1:N
                    fTCP = [fTCP, zOr(n)>=1-zLoop(l), zOr(n)>=zPhi(n),...
                        zOr(n)<= 1-zLoop(l)+zPhi(n)]; 
                end
            end
            % ztilde = And(zOr)
            for n = 1:N
                fTCP = [fTCP, ...
                repmat(ztilde(n),h-t,1) <= ZOr(:,n),...
                ztilde(n) >= 1-(h-t)+sum(ZOr(:,n))];     
            end

        end
    end
    
    % robustified version
    %r = getZ(strcat('Robust( ', formula, ')'), h, N);
    for n = 1:N
        fTCP = [fTCP, repmat(r(n),tau+1,1)<= zTilde(:,n), r(n) >= sum(zTilde(:,n))-tau];
    end
end
    
phi = getZ(formula.formula,k,1);

fTCP = [fTCP, sum(r) >= formula.m - (N+1)*(1-phi)];
fTCP = [fTCP, sum(r) <= formula.m + (N+1)*phi-1];
