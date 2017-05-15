function [fG,phiG] = getG(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon;


if length(args)~=1
    disp('G(globally) takes a single argument')
    assert(length(args)==1)
end


if k < length(Mw)

    % phi2 
    [fG,phi2] = getLTL(args{1},k);
    
    % G[[phi2]]_i+1
    [fG2,phiG2] = getG(formula, args, k+1);
    fG = [fG, fG2];

    % phiG_k = And(phi2_k,phiG_k+1)
    phiG = getZ(formula,k);
    fG = [fG, phiG<=phi2, phiG<=phiG2, phiG>=phiG2+phi2-1];
    
else


    % phi2 
    [fG,phi2] = getLTL(args{1},k);
    
    % za = << phi1 U phi2 >>
    za = [];
    
    % zb_i = And(zLoop_i,za_i)
    zb = [];
    
    % bigOr in (15)
    formulaAnd = 'And(';
    for i=1:k
       % za_i = << phi1 U phi2 >>_i 
       za_i = getZ(strcat('~',formula),i);
       za = [za;za_i];
       
       % zb_i = And(zLoop_i,za_i)
       formulaOr = strcat('Or(', ...
                    '(1-ZLoop)', '[',num2str(i),'],', ...
        strcat('~',formula), '[',num2str(i),'])');
       zb_i = getZ(formulaOr,-1);
       zb = [zb;zb_i];
       fG = [fG, zb(i)>=za(i), zb(i)>=1-ZLoop(i), zb(i)<=za(i)+1-ZLoop(i)];
       
       formulaAnd = strcat(formulaAnd, formulaOr, ',');
    
    end
    formulaAnd = strcat(formulaAnd,')');
    % bigOr, see eq (15) in paper
    zAnd2 = getZ(formulaAnd,-1);
    fG = [fG, zAnd2>=sum(zb)+1-k, repmat(zAnd2,k,1)<=zb];
    
    % finally (15)
    phiG = getZ(formula,k);
    fG = [fG, phiG>=zAnd2+phi2-1, phiG<=phi2, phiG<=zAnd2];
    
    % aux variables see (16)
    for i=1:k-1
        
        phi2_i = getZ(args{1},i);
        fG = [fG, za(i)>=za(i+1)+phi2_i-1, za(i)<=phi2_i, za(i)<=za(i+1)];
        
    end

    % Last step
    phi2_k = getZ(args{1},k);
    fG = [fG, za(k)==phi2_k];
    
end
    