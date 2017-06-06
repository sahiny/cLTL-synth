function [fX,phiX] = getX(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon;


if length(args)~=1
    disp('X(next) takes a single argument');
    assert(length(args)==1);
end


if k < length(Mw)

    % phi2 
    [fX,phiX] = getLTL(args{1},k+1);
   
else
    
    %constraints
    fX = [];
    
    % And(zLoop_i, args{1}_i)
    zAnd = [];
    
    for i=1:k
       
       phi_i = getZ(args{1},i);
       
       formulaAnd = strcat('And(', ...
                    'zLoop', '[',num2str(i),'],', ...
       num2str(args{1}), '[',num2str(i),'])');
       zAnd_i = getZ(formulaAnd,-1);
       zAnd = [zAnd;zAnd_i];
       
       fX = [fX, zAnd(i)<=phi_i, zAnd(i)<=zLoop(i), zAnd(i)>=phi_i+zLoop(i)-1];
           
    end

    % finally (13)
    phiX = getZ(formula,k);
    fX = [fX, repmat(phiX,k,1)>=zAnd, phiX<=sum(zAnd)];
    
end
    