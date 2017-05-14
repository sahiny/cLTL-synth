clear all;
close all;
clc;

load('TM.mat')


tic
A = TM;
h=20;
n = length(A);

% Initial deployment
I = [ones(6) zeros(6,7);
    zeros(3,13)];
I = find(I(:)==1);

WI = randi([0 5],numel(I),1);
W0 = zeros(length(A),1);
W0(I)=WI;
load W0mat

% Region1
G1 = [zeros(3,10) ones(3);
        zeros(6,13)];
G1 = find(G1(:)==1)';   

%region2
G2 = [zeros(5,13);
    ones(4) zeros(4,9)];
G2 = find(G2(:)==1)';

%region 3
G3 = [zeros(5,13);
    zeros(4,9) ones(4)];
G3 = find(G3(:)==1)';

% unsafe region
Obs = [zeros(6,13);
    zeros(3,4) ones(3) zeros(3,6);];
Obs = zeros(13,9);
Obs=Obs(:)==1;
%Obs = find(Obs(:)==1)';

% specs
f1 = strcat('F(G([',num2str(G2),',',num2str(round(sum(W0)/5)),']))');
fg1 = strcat('F(And([',num2str(G1),',',num2str(10),'],F([',num2str(G2),',10])))');
fg2 = strcat('G(F([',num2str(G2),',',num2str(80),']))');
fg3 = strcat('G(F([',num2str(G3),',',num2str(80),']))');
%f = strcat('And(',fg1,',',fg2,',',fg3,')');
f = strcat('And(',f1,',',fg1,',',fg2,',',fg3,')');



epsilon=0;
CA_flag=0;

[W,Mw,WT,ZLoop,LoopBegins] = main_cplex(f,A,h,W0,epsilon,Obs,CA_flag);
toc



