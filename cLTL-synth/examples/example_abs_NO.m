clear all;
close all;
clc;

global Mw Z zLoop ZLoop bigM epsilon;

load('TM2.mat')

tic
%A = flipud(TM)';
A = TM;
h=50;
n = length(A);
mygrid = ones(9,13);
% Initial deployment
% I = [zeros(5,13);
%      ones(4) zeros(4,9)];
% I = find(I(:)==1);
I = [1:3 14:16 27:29];
mygrid(I) = .5;
WI = randi([0 5],numel(I),1);
W0 = zeros(length(A),1);
W0(I)=WI;


% Region1
% G1 = [ones(4) zeros(4,9);
%         zeros(5,13)];
% G1 = find(G1(:)==1)';
G1 = I+ 10;
mygrid(G1) = .2;
%region2
% G2 = [zeros(4,9) ones(4);
%         zeros(5,13)];
% G2 = find(G2(:)==1)';
G2 = I+88;
mygrid(G2) = .2;
%region 3
% G3 = [zeros(5,13);
%     zeros(4,9) ones(4)];
% G3 = find(G3(:)==1)';
G3 = I+79;
mygrid(G3) = .2;
% unsafe region
% Obs = [zeros(3,5) ones(3,3) zeros(3,5);
%        zeros(2,4) zeros(2,5) ones(2,4)
%     zeros(4,13)];
% Obs=Obs(:)==1;
Obs = [7:13:33 53:55 63:65 85:13:111];
mygrid(Obs) = 0;
Obs = mygrid(:)==0;

vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;
imshow(kron(vis,ones(25,25)))
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


time = clock;
filename = ['./data/ex_abs_' ...
num2str(time(1)) '_'... % Returns year as character
num2str(time(2)) '_'... % Returns month as character
num2str(time(3)) '_'... % Returns day as char
num2str(time(4)) 'h'... % returns hour as char..
num2str(time(5)) 'm'... %returns minute as char
];
save(filename,'WT','WT','Mw','Mw','ZLoop','ZLoop','A','A','mygrid','mygrid', 'Z', 'Z');

