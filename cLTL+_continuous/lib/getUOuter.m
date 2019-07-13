function [fU,phi] = getUOuter(formula, k)

global x u Z zLoop ZLoop bigM epsilon tau;
args = formula.args;
if length(args)~=2
    disp('U takes two arguments')
    return
end

% number of agents
N = length(x);
% number of states
I = size(x{1},1);
% time horizon
h = size(u{1},2);


if k < h
    
    % phi1
    [fU,phi1] = getLTL(args{1}, k);
    
    % phi2 
    [f2,phi2] = getLTL(args{2},k);
    fU = [fU, f2];
    
    % [[phi1 U phi2]]_i+1
    [fU2,phiU2] = getLTL(formula, k+1);
    fU = [fU, fU2];
    
    % And(phi1_k, [[phi1 U phi2]]_k+1)
    formulaAnd = strcat('And(', num2str(args{1}.formula), ',', formula.formula, ')');
    zAnd = getZ(formulaAnd, k, 1);
    fU = [fU, zAnd <= phi1, zAnd <= phiU2, zAnd >= phiU2+phi1-1];
    
    % phiU_k = Or(phi2_k,zAnd)
    phi = getZ(formula.formula,k,1);
%     phi = phiU(k);
    fU = [fU, phi >= phi2, phi >= zAnd, phi <= zAnd+phi2];
    
else

    % phi1
    [fU,phi1] = getLTL(args{1},k);
    
    % phi2 
    [f2,phi2] = getLTL(args{2},k);
    fU = [fU, f2];
    
    % bigOr in (15)
    za_i = getZ(strcat('~',formula.formula),1,h);
    formulaAnd = strcat('And(zLoop, ',strcat('~',formula.formula), ')');
    zb_i = getZ(formulaAnd,k,h);
    for i=1:h
       % zb_i = And(zLoop_i,za_i)
       fU = [fU, zb_i(i)<=za_i(i), zb_i(i)<=zLoop(i), zb_i(i)>=za_i(i)+zLoop(i)-1];
    end
    formulaOr = strcat('Or', formulaAnd,')');
    % bigOr, see eq (15) in paper
    zOr = getZ(formulaOr,1,1);
    fU = [fU, zOr<=sum(zb_i), repmat(zOr,1,h)>=zb_i];
    
    % second term in paranthesis (15)
    formulaAnd = strcat('And( ',num2str(args{1}.formula), ',',formulaOr, ')');
    zAnd = getZ(formulaAnd,1,1);
    fU = [fU, zAnd<=zOr, zAnd<=phi1, zAnd>=phi1+zOr-1];
    
    % finally (15)
    phi = getZ(formula.formula,k,1);
    %phi = phiU(h);
    fU = [fU, phi<=zAnd+phi2, phi>=phi2, phi>=zAnd];

    % second term in paranthesis (16)
    formulaAnd = strcat('And( ',num2str(args{1}.formula), strcat('~',formula.formula), ')'); 
    zAnd = getZ(formulaAnd,1,h);
    % aux variables see (16)
    for i=1:h-1
       phi1 = getZ(args{1}.formula,i,1);
       fU = [fU, zAnd(i)<=za_i(i+1), zAnd(i)<=phi1, zAnd(i)>=za_i(i+1)+phi1-1];
       
       phi2 = getZ(args{2}.formula,i,1);
       fU = [fU, za_i(i)<=zAnd(i)+phi2, za_i(i)>=phi2, za_i(i)>=zAnd(i)];
        
    end

    % Last step
    phi2 = getZ(args{2}.formula,h,1);
    fU = [fU, za_i(h)==phi2];

end
