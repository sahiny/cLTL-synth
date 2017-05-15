function fDyn = getDyn(A,k)

% Returns system dynamic constraints
global Mw Z zLoop ZLoop bigM epsilon;

% number of states
n = length(A);
% Indices of 0's of adjacency matrix
%A0 = A(:)==0;
A1 = A(:)==1;
% Flow constraints
fDyn=[];
for i = 2:k
    fDyn = [fDyn, Mw{i}*ones(n,1)==transpose(ones(1,n)*Mw{i-1})];
    fDyn = [fDyn, Mw{i}(A1)>=0];
end


