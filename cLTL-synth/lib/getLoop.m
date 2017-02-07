function fLoop= getLoop(h)
% Returns loop constraints
global Mw zLoop ZLoop bigM ;

% number of states
n = length(Mw{1});

% Loop variables
% zLoop(i)=1 where loop starts
zLoop = binvar(h,1);
% ZLoop(i)=1 for all i in loop
ZLoop = [];
% Loop constraints
fLoop = sum(zLoop)==1;

for i=1:h
fLoop = [fLoop, ones(1,n)*Mw{h}<=transpose(Mw{i}*ones(n,1)) + bigM*(1-zLoop(i))];
fLoop = [fLoop, ones(1,n)*Mw{h}>=transpose(Mw{i}*ones(n,1)) - bigM*(1-zLoop(i))];
ZLoop = [ZLoop; sum(zLoop(1:i))];
end

% Check if loop started, i.e., ZLoopi = Or(zLoopi, Neg(sum(zLoop(i:end))))

