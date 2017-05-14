clear all;
close all;
clc;

load('TM.mat')


tic
A = TM;
h=50;
n = length(A);

% Initial deployment
I = [zeros(3,13);
     ones(6) zeros(6,7)];
I = find(I(:)==1);

WI = randi([0 10],numel(I),1);
W0 = zeros(length(A),1);
W0(I)=WI;

% Region1
G1 = [ones(2) zeros(2,11);
        zeros(7,13)];
G1 = find(G1(:)==1)';   

%region2
G2 = [zeros(2,11) ones(2);
        zeros(7,13)];
G2 = find(G2(:)==1)';

%region 3
G3 = [zeros(7,13);
    zeros(2,11) ones(2)];
G3 = find(G3(:)==1)';

% unsafe region
Obs = [zeros(3,4) ones(3) zeros(3,6);
    zeros(6,13)];
Obs=Obs(:)==1;
%Obs = find(Obs(:)==1)';

% specs
f1 = strcat('F(G([',num2str(G2),',',num2str(sum(W0)/5),']))');
fg1 = strcat('F(And([',num2str(G1),',',num2str(3),'],F([',num2str(G2),',3])))');
fg2 = strcat('G(F([',num2str(G2),',',num2str(3),']))');
fg3 = strcat('G(F([',num2str(G3),',',num2str(3),']))');
f = strcat('And(',fg1,',',fg2,',',fg3,')');
% f = strcat('And(',f1,',',fg1,',',fg2,',',fg3,')');

epsilon=0;
CA_flag=0;

mytimes = main_cplex(f,A,h,W0,epsilon,Obs,CA_flag);
toc



