clear all;clc;
global x Z zLoop ZLoop bigM;
N = 5;
h = 13;
A = rand(2);
B = rand(2);

dx = size(A,1);
du = size(B,2);

u = sdpvar(repmat(du,1,N),repmat(h,1,N),'full');
x = sdpvar(repmat(du,1,N),repmat(h+1,1,N),'full');
Z = {};

ap_cell = {};

[ap1, ap_cell] = AP(rand(4,2), 5*rand(4,1), ap_cell);
[ap2, ap_cell] = AP(rand(4,2), 5*rand(4,1), ap_cell);
[ap3, ap_cell] = AP(rand(4,2), 5*rand(4,1), ap_cell);


formula = And(G(F(TCP(ap1, 3))), TCP(U(Or(ap1, ap2), Neg(ap3)),4));

[x, u, Z, mytimes, sol] = main_template(...
    formula, A, B, Px, Pu, h, X0, Obs, CA_flag)