function [fLTL,phi] = getLTL(formula,k)

global W Wtotal Z zLoop ZLoop bigM epsilon tau;

[Op,args] = parseLTL(formula);

switch Op
    case 'And'
        [fLTL,phi] = getAnd(formula,args,k);
    case 'Or'
        [fLTL,phi] = getOr(formula,args,k);
    case 'Neg'
        [fLTL,phi] = getNeg(formula,args,k);
    case 'AndI'
        [fLTL,phi] = getAndI(formula,args,k);
    case 'OrI'
        [fLTL,phi] = getOrI(formula,args,k);
    case 'NegI'
        [fLTL,phi] = getNegI(formula,args,k);
    case 'G'
        [fLTL,phi] = getG(formula,args,k);
    case 'F'
        [fLTL,phi] = getF(formula,args,k);
    case 'X'
        [fLTL,phi] = getX(formula,args,k);
    case 'U'
        [fLTL,phi] = getU(formula,args,k);
    case 'GG'
        [fLTL,phi] = getGG(formula,args,k);
    case 'FF'
        [fLTL,phi] = getFF(formula,args,k);
    case 'FG'
        [fLTL,phi] = getFG(formula,args,k);
    case 'GF'
        [fLTL,phi] = getGF(formula,args,k);
    case 'GGI'
        [fLTL,phi] = getGGI(formula,args,k);
    case 'FFI'
        [fLTL,phi] = getFFI(formula,args,k);
    case 'FGI'
        [fLTL,phi] = getFGI(formula,args,k);
    case 'GFI'
        [fLTL,phi] = getGFI(formula,args,k);
    case 'TP'
        [fLTL,phi] = getTPTau(formula,args,k);
    otherwise
        disp('wrong formula');
end
    