clear;close all;clc;

% create a random polytope
n = 20;
x = rand(n,2);
k = convhull(x);
P = Polyhedron(x(k(1:end-1),:));

y = 2*x;

% plot(P)
% hold on
% plot(y(:,1),y(:,2),'.b');
% plot(x(:,1),x(:,2),'.y');
% 
% hold off

p = sdpvar(size(y,1),1);
const = [];
H = 0;
for i = 1:size(y,1)
    const = [const, P.A*(y(i,:)') + ones(length(P.b),1)*p(i) <= P.b ];
    H = H-p;
end

sol= optimize(const,H);
value(p)
