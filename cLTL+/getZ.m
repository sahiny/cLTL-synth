function z = getZ(formula,k,n)

if strcmp(formula,'True') || strcmp(formula,' True')
    z = 1;
    return
end

global Z;

if isnumeric(formula)
    formula = strcat('[ ', num2str(formula), ']');
end

formula = num2str(formula);


i = find(strcmp([Z{:}],formula));

if isempty(i)
    %create new sdpvar if not created before
    z = binvar(k,n,'full');
    Z{length(Z)+1} = {z,formula};
else
    % else return the existing one
    z = Z{i/2}{1};
end