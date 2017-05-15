function [fU,phiU] = getU(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon;


if length(args)~=2
    disp('U(until) takes a two argument')
    assert(length(args)==2)
end


if k < length(Mw)
    
    % phi1
    [fU,phi1] = getLTL(args{1},k);
    
    % phi2 
    [f2,phi2] = getLTL(args{2},k);
    fU = [fU, f2];
    
    % [[phi1 U phi2]]_i+1
    [fU2,phiU2] = getU(formula, args, k+1);
    fU = [fU, fU2];
    
    % And(phi1_k, [[phi1 U phi2]]_k+1)
    formulaAnd = strcat('And(', ...
        num2str(args{1}), '[',num2str(k),'],', ...
                 formula, '[',num2str(k+1),'])');
    zAnd = getZ(formulaAnd,-1);
    fU = [fU, zAnd<=phi1, zAnd<=phiU2, zAnd>=phiU2+phi1-1];
    
    % phiU_k = Or(phi2_k,zAnd)
    phiU = getZ(formula,k);
    fU = [fU, phiU>=phi2, phiU>=zAnd, phiU<=zAnd+phi2];
    
else

    % phi1
    [fU,phi1] = getLTL(args{1},k);
    
    % phi2 
    [f2,phi2] = getLTL(args{2},k);
    fU = [fU, f2];
    
    % za = << phi1 U phi2 >>
    za = [];
    
    % zb_i = And(zLoop_i,za_i)
    zb = [];
    
    % bigOr in (15)
    formulaOr = 'Or( ';
    for i=1:k
       % za_i = << phi1 U phi2 >>_i 
       za_i = getZ(strcat('~',formula),i);
       za = [za;za_i];
       
       % zb_i = And(zLoop_i,za_i)
       formulaAnd = strcat('And(', ...
                    'zLoop', '[',num2str(i),'],', ...
        strcat('~',formula), '[',num2str(i),'])');
       zb_i = getZ(formulaAnd,-1);
       zb = [zb;zb_i];
       fU = [fU, zb(i)<=za(i), zb(i)<=zLoop(i), zb(i)>=za(i)+zLoop(i)-1];
       
       formulaOr = strcat(formulaOr, formulaAnd, ',');
    
    end
    formulaOr = strcat(formulaOr,')');
    % bigOr, see eq (15) in paper
    zOr = getZ(formulaOr,-1);
    fU = [fU, zOr<=sum(zb), repmat(zOr,k,1)>=zb];
    
    % second term in paranthesis (15)
    formulaAnd = strcat('And( ', ...
        num2str(args{1}), '[',num2str(k),'], ', ...
               formulaOr, '[-1]');
    zAnd = getZ(formulaAnd,-1);
    fU = [fU, zAnd<=zOr, zAnd<=phi1, zAnd>=phi1+zOr-1];
    
    % finally (15)
    phiU = getZ(formula,k);
    fU = [fU, phiU<=zAnd+phi2, phiU>=phi2, phiU>=zAnd];
    
    % aux variables see (16)
    for i=1:k-1
       % second term in paranthesis (16)
       formulaAnd = strcat('And( ', ...
         num2str(args{1}), '[',num2str(i),'], ', ...
      strcat('~',formula), '[', num2str(i+1),'])'); 
  
       zAnd = getZ(formulaAnd,-1);
       phi1_i = getZ(args{1},i);
       fU = [fU, zAnd<=za(i+1), zAnd<=phi1_i, zAnd>=za(i+1)+phi1_i-1];
       
        phi2_i = getZ(args{2},i);
        fU = [fU, za(i)<=zAnd+phi2_i, za(i)>=phi2_i, za(i)>=zAnd];
        
    end

    % Last step
    phi2_k = getZ(args{2},k);
    fU = [fU, za(k)==phi2_k];
    
end
    