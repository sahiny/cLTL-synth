function z = getZ(name,k)
%
% if an sdpvar with given name already exists returns it,
% else, creates an sdpvar with given name and returns it
%
% INPUTS
% name = string
%
% OUTPUTS
% z = sdpvariable with given name

if strcmp(name,'True') || strcmp(name,' True')
    z = 1;
    return
end

if isnumeric(name)
    name = strcat('[ ', num2str(name), ']');
end


name = strcat(num2str(name),'[',num2str(k),']');

global Z;
i = find(strcmp([Z{:}],name));

if isempty(i)
    %create new sdpvar if not created before
    z = binvar(1);
    Z{length(Z)+1} = {z,name};
else
    % else return the existing one
    z = Z{i/2}{1};
end