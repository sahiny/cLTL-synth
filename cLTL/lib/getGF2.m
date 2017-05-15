function [fGF,phiGF] = getGF2(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon;

h = length(Mw);

if length(args)~=1
    disp('GF(eventually) takes a single argument')
    assert(length(args)==1)
end

    fGF = [];
    ZAnd = [];
    z = [];
    for i=1:h
       % za_i = << phi1 U phi2 >>_i 
       [fLTL,zi] = getLTL(args{1},k);
       fGF = [fGF, fLTL];
       z = [z;zi];

       % zb_i = And(zLoop_i,za_i)
       formulaAnd = strcat('And(', ...
                    'ZLoop', '[',num2str(i),'],', ...
        num2str(args{1}), '[',num2str(i),'])');
       zAnd = getZ(formulaAnd,-1);
       ZAnd = [ZAnd;zAnd];
       fGF = [fGF, ZAnd(i)<=z(i), ZAnd(i)<=ZLoop(i), ZAnd(i)>=z(i)+ZLoop(i)-1];
           
    end
        
    % finally (15)
    phiGF = getZ(formula,1);
    fGF = [fGF, phiGF<=sum(ZAnd), repmat(phiGF,h,1)>=ZAnd];
    

    