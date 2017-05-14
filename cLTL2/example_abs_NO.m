clear all;
close all;
clc;

global Mw Z zLoop ZLoop bigM epsilon;

load('TM.mat')

tic
A = TM;
h=20;
n = length(A);
mygrid = zeros(9,13);
% Initial deployment
I = [zeros(3,13);
     ones(6) zeros(6,7)];
I = find(I(:)==1);
mygrid(I) = .5;
WI = randi([0 5],numel(I),1);
W0 = zeros(length(A),1);
W0(I)=WI;
load W0mat

% Region1
G1 = [ones(3) zeros(3,10);
        zeros(6,13)];
G1 = find(G1(:)==1)';   
mygrid(G1) = .2;
%region2
G2 = [zeros(4,9) ones(4);
        zeros(5,13)];
G2 = find(G2(:)==1)';
mygrid(G2) = .2;
%region 3
G3 = [zeros(5,13);
    zeros(4,9) ones(4)];
G3 = find(G3(:)==1)';
mygrid(G3) = .2;
% unsafe region
Obs = [zeros(3,4) ones(3) zeros(3,6);
    zeros(6,13)];
Obs=Obs(:)==1;
mygrid(Obs) = 1;
%Obs = find(Obs(:)==1)';

% specs
f1 = strcat('FG([',num2str(G2),',',num2str(round(sum(W0)/5)),'])');
fg1 = strcat('F(And([',num2str(G1),',',num2str(10),'],F([',num2str(G2),',10])))');
fg2 = strcat('GF([',num2str(G2),',',num2str(10),'])');
fg3 = strcat('GF([',num2str(G3),',',num2str(10),'])');
%f = strcat('And(',fg1,',',fg2,',',fg3,')');
f = strcat('And(',f1,',',fg1,',',fg2,',',fg3,')');

epsilon=0;
CA_flag=0;

[Mw, WT, Z, mytimes] = main_template(f,A,h,W0,Obs,CA_flag);
toc

save('Abs.mat','W','W','Mw','Mw','WT','WT','LoopBegins','LoopBegins','W0','W0','grid','grid','A','A')


