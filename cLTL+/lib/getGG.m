function [fGG,phi] = getGG(formula,args,k)

global W Wtotal Z zLoop ZLoop bigM epsilon tau;

if length(args)>1
    disp('GG takes a single argument');
    asset(length(args)==1);
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1-tau;

fGG = [];
z = [];
for k = 1:h
    % Get its constraints
    [fAP,phiAP] = getLTL(args{1},k);
    fGG = [fGG, fAP];
    z = [z; phiAP];
end

phi = binvar(1);
Z{length(Z)+1} = {phi,formula};
% conjunction constraint
fGG = [fGG, repmat(phi,h,1)<=z, phi>=1-h+sum(z)];
