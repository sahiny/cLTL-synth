function [fAP,phi] = getAP(formula,k, S)

global x Z zLoop ZLoop bigM;

assert(strcmp(formula.args{1}.Op, 'AP'))

% number of agents
N = length(x);
% Polytope properties for ap
A = formula.A;
b = formula.b;
m = size(A,1);


phi = getZ(formula.formula,k,N);
zAP = [];
fAP = [];
for n = S
    xk = x{n}(:,k);
    ztemp = getZ(strcat('~',formula.formula,'[',num2str(n),']'),k,m);
    zAP = [zAP;ztemp];
    
    for r = 1:m
        fAP = [fAP, A(r,:)*xk <= b(r) + bigM*(1-ztemp(r)),...
            A(r,:)*xk >= b(r) + 0.01 - bigM*ztemp(r)];

    end
    
    fAP = [fAP, repmat(phi(n),1,m)<= ztemp, phi(n)>= sum(ztemp)+1-m];
end
