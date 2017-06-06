function fDyn = getDyn(A,CA_flag)
% returns dynamical constraints
global W;
% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

fDyn = [];
for n = 1:N
    fDyn = [fDyn, sum(W{n}) == ones(1,h+1)];
    others = find([1:N]~=n);
    for i = 2:h+1
        wnext = W{n}(:,i);
        wcurrent = W{n}(:,i-1);
        %fDyn = [fDyn, sos1(wnext,ones(I,1))];
        % move according to adj matrix
        fDyn = [fDyn, wnext <= A*wcurrent];
        if CA_flag
            for other = 1:N-1
                wother_current = W{others(other)}(:,i-1);
                fDyn = [fDyn, wnext <= ones(size(I))-wother_current];
            end
        end
        % conservation of mass
        %fDyn = [fDyn, sum(W{n}(:,i-1))==1];
        % non-negative number of agents
        %fDyn = [fDyn, wnext >= zeros(I,1)];
    end
end


