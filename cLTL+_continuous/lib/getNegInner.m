function [fNeg,phi] = getNegInner(formula,k)

global x Z zLoop ZLoop bigM;

% number of agents
N = length(x);

% number of arguments
assert(length(formula.args)==1, 'Neg takes 1 argument');

% Get its constraints
[fNeg,zNeg] = getLTL(formula.args{1},k);
phi = ones(1,N) - zNeg;
Z{length(Z)+1} = {phi,strcat(formula.formula,'[',num2str(k),']')};