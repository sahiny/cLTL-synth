function [fAnd,phi] = getNegOuter(formula,k)

global x Z zLoop ZLoop bigM;
% number of agents
N = length(x);
% number of states
I = size(x{1},1);
% time horizon
h = size(x{1},2)-1;

% m*N binvar: a binary variable for each argument and agent 
z = [];

% Constraints
fAnd = [];

% number of arguments
assert(length(formula.args)==1, 'Neg takes 1 arguments');

[fAP,phiAP] = getLTL(formula.args{1},k);
fAnd = [fAnd, fAP];
z = [z; phiAP];

phi = 1-z;
Z{length(Z)+1} = {phi,strcat(formula.formula,'[',num2str(k),']')};