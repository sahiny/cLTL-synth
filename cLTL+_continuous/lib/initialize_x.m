function x = initialize_x(X0)
% states
x = cell(1,size(X0,2));

% Initial conditions
for n = 1:length(x)
    x{n}(:,1) = X0(:,n);
end