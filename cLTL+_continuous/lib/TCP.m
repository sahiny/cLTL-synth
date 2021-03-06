function tcp = TCP(phi,m)
assert(strcmp(phi.type, 'inner') || strcmp(phi.type, 'ap'), ...
    'first argument must be written according to inner syntax');
assert(isnumeric(m), 'second argument must be numeric');
tcp = struct('type', 'outer', 'phi', phi, 'm', m, 'Op', 'TCP', ...
    'formula', strcat('TCP(', phi.formula, ', ', num2str(m), ')'));
tcp.args = {tcp};