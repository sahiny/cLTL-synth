function z = getZ(formula,k,n)

if strcmp(formula,'True') || strcmp(formula,' True')
    z = 1;
    return
end

global Z;
formula = strcat(num2str(formula),...
    '[',num2str(k),']');
i = find(strcmp([Z{:}],formula));

if isempty(i)
    %create new sdpvar if not created before
    z = binvar(1,n,'full');
    Z{length(Z)+1} = {z,formula};
else
    % else return the existing one
    z = Z{i/2}{1};
end