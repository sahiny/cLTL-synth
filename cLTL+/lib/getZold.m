function z = getZold(formula,k,n)

if strcmp(formula,'True') || strcmp(formula,' True')
    z = 1;
    return
end

global W Z;
% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

if isnumeric(formula)
    formula = strcat('[ ', num2str(formula), ']');
end

formula = num2str(formula);


i = find(strcmp([Z{:}],formula));

if isempty(i)
    %create new sdpvar if not created before
    if n >= 0 % for inner formulas
        z = binvar(h,N,'full');
        Z{length(Z)+1} = {z,formula};
        z = z(k,:);
        if n>0
            z = z(n);
        end
    else
        if k >= 0 % for outer formulas
            z = binvar(h,1);
            Z{length(Z)+1} = {z,formula};
            if k>0
                z = z(k);
            end
        else
            z = binvar(1);
            Z{length(Z)+1} = {z,formula};
        end
    end
    
else
    % else return the existing one
    if n > 0 
        z = Z{i/2}{1}(k,n);
    elseif n == 0
        z = Z{i/2}{1}(k,:);
    else
        if k > 0
            z = Z{i/2}{1}(k);
        else
            z = Z{i/2}{1};
        end
    end
end