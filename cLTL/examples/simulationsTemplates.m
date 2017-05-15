clear all;close all;clc;
time = clock;
filename = ['simTempResults' ...
num2str(time(1)) '_'... % Returns year as character
num2str(time(2)) '_'... % Returns month as character
num2str(time(3)) '_'... % Returns day as char
num2str(time(4)) 'h'... % returns hour as char..
num2str(time(5)) 'm'... %returns minute as char
];

numTrial = 10;
edgeprob = (2/3);

numAgents = [20, 100, 5000, 100000];%numAgents=[];
TAgents = cell(5,length(numAgents));

numStates = [100, 200, 500];
%numStates=[];
TStates = cell(5,length(numStates));

timeHorizon = [20,50,100,200];
Th = cell(5,length(timeHorizon));

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(' ...................Changing number of States........................')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

nAgent=20;
h=20;

for i=1:length(numStates)
    disp(['--------------------- #States............................',num2str(numStates(i)),]);
    ti = tic;
    nState = numStates(i);
       S = randperm(nState);
       S1 = S(1:nState/2);
       S2 = S(nState/2+1:end);
       G = S(datasample(S,3*nState/10));
       G1 = G(1:nState/10);
       G2 = G(nState/10+1:2*nState/10);
       G3 = G(2*nState/10+1:3*nState/10);
       f1 = strcat('FG([',num2str(S2),',',num2str(nAgent/2),'])');
       fg1 = strcat('GF([',num2str(G1),',',num2str(nAgent/3),'])');
       fg2 = strcat('GF([',num2str(G2),',',num2str(nAgent/3),'])');
       fg3 = strcat('GF([',num2str(G3),',',num2str(nAgent/3),'])');
       f = strcat('And(',f1,',',fg1,',',fg2,',',fg3,')');
       Obs = ones(nState,1);
       Obs = Obs(:) == 0;
       CA_flag=0;
       te=0;
    for j=1:numTrial
       clear Mw Z zLoop ZLoop bigM epsilon;
       global Mw Z zLoop ZLoop bigM epsilon;
       epsilon=0;
       tj = tic;
       disp(['----- #Trial................................',num2str(j)]);
       A = round(edgeprob*rand(nState));
       W0S1 = diff([0,sort(randperm(nAgent+nState/2-1,nState/2-1)),nAgent+nState/2])-ones(1,nState/2);
       W0 = zeros(nState,1);
       W0(S1) = W0S1';
       [~,~,~,mytimes] = main_template(f,A,h,W0,Obs,CA_flag);
       TStates{i,j} = mytimes;
       disp(['Time spent in main function: ', num2str(mytimes(1)) ,' seconds: (',num2str(mytimes(2:end)),')'])
       te = toc(tj);
       disp(['Time spent in trial #',num2str(j) ,':  ',num2str(te),' seconds']);
           save(filename,'TAgents','TAgents','TStates','TStates','Th','Th');    
    end
    te = te + toc(ti);
       disp(['Avg Time spent in ', num2str(numTrial),' trial(s): ',num2str(te/numTrial), ' seconds']);
end

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('...................Changing number of Agents........................')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
h=20;
nState=100;
S = randperm(nState);
S1 = S(1:nState/2);
S2 = S(nState/2+1:end);
G = S(datasample(S,3*nState/10));
G1 = G(1:nState/10);
G2 = G(nState/10+1:2*nState/10);
G3 = G(2*nState/10+1:3*nState/10);
Obs = ones(nState,1);
Obs = Obs(:) == 0;
CA_flag=0;

for i=1:length(numAgents)
    ti=tic;
    disp(['#################### Agents............................',num2str(numAgents(i)),]);
       nAgent = numAgents(i);
       f1 = strcat('FG([',num2str(S2),',',num2str(nAgent/2),'])');
       fg1 = strcat('GF([',num2str(G1),',',num2str(round(nAgent/5)),'])');
       fg2 = strcat('GF([',num2str(G2),',',num2str(round(nAgent/5)),'])');
       fg3 = strcat('GF([',num2str(G3),',',num2str(round(nAgent/5)),'])');
       f = strcat('And(',f1,',',fg1,',',fg2,',',fg3,')');
       te = 0;
    for j=1:numTrial
       clear Mw Z zLoop ZLoop bigM epsilon;
       global Mw Z zLoop ZLoop bigM epsilon;
       epsilon=0;
       tj=tic;
       disp(['######Trial................................',num2str(j)]);
       A = round(edgeprob*rand(nState));
       W0S1 = diff([0,sort(randperm(nAgent+nState/2-1,nState/2-1)),nAgent+nState/2])-ones(1,nState/2);
       W0 = zeros(nState,1);
       W0(S1) = W0S1';
       [~,~,~,mytimes] = main_template(f,A,h,W0,Obs,CA_flag);
       TAgents{i,j} = mytimes;
       disp(['Time spent in main function: ', num2str(mytimes(1)) ,' seconds: (',num2str(mytimes(2:end)),')'])
       te = toc(tj);
       disp(['Time elapsed in trial #',num2str(j) ,':  ',num2str(te),' seconds']); 
           save(filename,'TAgents','TAgents','TStates','TStates','Th','Th');    
    end
       te = te+ toc(ti);
       disp(['Time elapsed in ', num2str(numTrial),' trial(s): ',num2str(te/numTrial), ' seconds']);
end



disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(' ...................Changing k.......................................')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

nAgent=20;
nState=100;
S = randperm(nState);
S1 = S(1:nState/2);
S2 = S(nState/2+1:end);
G = S(datasample(S,5*nState/10));
G1 = G(1:nState/10);
G2 = G(nState/10+1:2*nState/10);
G3 = G(2*nState/10+1:3*nState/10);
G4 = G(3*nState/10+1:4*nState/10);
G5 = G(4*nState/10+1:5*nState/10);
f1 = strcat('FG([',num2str(S2),',',num2str(nAgent/2),'])');
       fg1 = strcat('GF([',num2str(G1),',',num2str(round(nAgent/5)),'])');
       fg2 = strcat('GF([',num2str(G2),',',num2str(round(nAgent/5)),'])');
       fg3 = strcat('GF([',num2str(G3),',',num2str(round(nAgent/5)),'])');
ff = strcat('F(And([',num2str(G1),',',num2str(3),']');
%ff = strcat(ff,',F(And([',num2str(G2),',',num2str(3),']');
Obs = ones(nState,1);
Obs = Obs(:) == 0;
CA_flag=0;

for i=1:length(timeHorizon)
        ti = tic;
    disp(['#################### k............................',num2str(timeHorizon(i)),]);
       h = timeHorizon(i);
        if h == timeHorizon(2) || h==timeHorizon(3) 
        ff2 = strcat(ff,',F(And([',num2str(G3),',',num2str(3),']))');
        %ff2 = strcat(ff2,',F(And([',num2str(G4),',',num2str(3),']))))');
       elseif h==timeHorizon(4)               
        ff2 = strcat(ff,',F(And([',num2str(G3),',',num2str(3),']');
        ff2 = strcat(ff2,',F(And([',num2str(G4),',',num2str(3),']');
        ff2 = strcat(ff2,',F(And([',num2str(G5),',',num2str(3),']))))))');
       else
           ff2 = ff;
       end
       ff3 = strcat(ff2,'))');
       f = strcat('And(',f1,',',fg1,',',fg2,',',fg3,',',ff3,')'); 
       te = 0;
    for j=1:numTrial
       clear Mw Z zLoop ZLoop bigM epsilon;
       global Mw Z zLoop ZLoop bigM epsilon;
       epsilon=0;
       disp(['######Trial................................',num2str(j)]);
       tj =tic;
       A = round(edgeprob*rand(nState));
       W0S1 = diff([0,sort(randperm(nAgent+nState/2-1,nState/2-1)),nAgent+nState/2])-ones(1,nState/2);
       W0 = zeros(nState,1);
       W0(S1) = W0S1';
       [~,~,~,mytimes] = main_template(f,A,h,W0,Obs,CA_flag);
       Th{i,j} = mytimes;
       disp(['Time spent in main function: ', num2str(mytimes(1)) ,' seconds: (',num2str(mytimes(2:end)),')'])
       te = toc(tj);
       disp(['Time elapsed in trial #',num2str(j) ,':  ',num2str(te),' seconds']);  
    end
       te = te+ toc(ti);
       disp(['Time elapsed in ', num2str(numTrial),' trial(s): ',num2str(te/numTrial), ' seconds']);
    save(filename,'TAgents','TAgents','TStates','TStates','Th','Th');    
end


disp(['--------------------------------------------']);
disp(['--------------------------------------------'])

disp(['--------------------------------------------'])

disp(['--------------------------------------------'])


simulations;

