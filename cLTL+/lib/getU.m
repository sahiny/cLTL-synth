function [fU,phi] = getU(formula, args, k)

global W Wtotal Z zLoop ZLoop bigM epsilon tau;

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1-tau;

z = [];
%fU = [];


if length(args)~=2
    disp('U(until) takes a two argument')
    assert(length(args)==2)
end


if k < h
    
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
        num2str(args{1}), ',', ...
                 formula, ')');
    zAnd = getZ(formulaAnd,h-1,1);
    fU = [fU, zAnd(k)<=phi1, zAnd(k)<=phiU2, zAnd(k)>=phiU2+phi1-1];
    
    % phiU_k = Or(phi2_k,zAnd)
    phiU = getZ(formula,h,1);
    phi = phiU(k);
    fU = [fU, phi>=phi2, phi>=zAnd(k), phi<=zAnd(k)+phi2];
    
else

    % phi1
    [fU,phi1] = getLTL(args{1},k);
    
    % phi2 
    [f2,phi2] = getLTL(args{2},k);
    fU = [fU, f2];
    
    % za = << phi1 U phi2 >>
    za_i = [];
    
    % zb_i = And(zLoop_i,za_i)
    zb_i = [];
    
    % bigOr in (15)
    formulaOr = 'Or( ';
    za_i = getZ(strcat('~',formula),h,1);
           formulaAnd = strcat('And(', ...
                    'zLoop', ...
        strcat('~',formula), ')');
       zb_i = getZ(formulaAnd,h,1);
    for i=1:h
       % za_i = << phi1 U phi2 >>_i 
       %za = [za;za_i];
       % zb_i = And(zLoop_i,za_i)

       %zb = [zb;zb_i];
       fU = [fU, zb_i(i)<=za_i(i), zb_i(i)<=zLoop(i), zb_i(i)>=za_i(i)+zLoop(i)-1];
       
       formulaOr = strcat(formulaOr, formulaAnd, ',');
    
    end
    formulaOr = strcat(formulaOr,')');
    % bigOr, see eq (15) in paper
    zOr = getZ(formulaOr,1,1);
    fU = [fU, zOr<=sum(zb_i), repmat(zOr,h,1)>=zb_i];
    
    % second term in paranthesis (15)
    formulaAnd = strcat('And( ', ...
        num2str(args{1}), ',', ...
               formulaOr, ')');
    zAnd = getZ(formulaAnd,1,1);
    fU = [fU, zAnd<=zOr, zAnd<=phi1, zAnd>=phi1+zOr-1];
    
    % finally (15)
    phiU = getZ(formula,h,1);
    phi = phiU(h);
    fU = [fU, phi<=zAnd+phi2, phi>=phi2, phi>=zAnd];

           % second term in paranthesis (16)
       formulaAnd = strcat('And( ', ...
         num2str(args{1}),  ...
      strcat('~',formula), ')'); 
    zAnd = getZ(formulaAnd,h-1,1);
    % aux variables see (16)
    for i=1:h-1
       phi1 = getZ(args{1},h,1);
       fU = [fU, zAnd(i)<=za_i(i+1), zAnd(i)<=phi1(i), zAnd(i)>=za_i(i+1)+phi1(i)-1];
       
        phi2 = getZ(args{2},h,1);
        fU = [fU, za_i(i)<=zAnd(i)+phi2(i), za_i(i)>=phi2(i), za_i(i)>=zAnd(i)];
        
    end

    % Last step
    phi2_k = getZ(args{2},h,1);
    fU = [fU, za_i(h)==phi2(h)];

end
    