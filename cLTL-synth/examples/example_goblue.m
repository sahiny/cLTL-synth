% Trivially feasible, Yalmip claims otherwise
close all;clear;clc;
global Mw Z zLoop ZLoop bigM epsilon;

um_goblue2

A = adj+eye(size(adj));
n = length(A);
%A = ones(13*21)-eye(13*21);
h = 50;
N = 76;
f = strcat('And(',f_um,',',f_go,')');
fps = 1;

% m=1:N;
% W0= m(sort(randperm(N,n)));
% W0=diff(W0)';
% W0(end+1)=N-sum(W0);
W0 = zeros(length(A),1);
W0(1)=N;

epsilon=0;
CA_flag=0;

tic
[Mw,WT,Z,~] = cLTL_synth(f,A,h,W0,Obs,CA_flag);
toc

time = clock;

filename = ['GOBLUE_' ...
num2str(time(1)) '_'... % Returns year as character
num2str(time(2)) '_'... % Returns month as character
num2str(time(3)) '_'... % Returns day as char
num2str(time(4)) 'h'... % returns hour as char..
num2str(time(5)) 'm'... %returns minute as char
];


save(filename,'WT','WT','Mw','Mw','ZLoop','ZLoop','A','A','mygrid','mygrid','Z','Z');

plot_trace(filename,fps);
