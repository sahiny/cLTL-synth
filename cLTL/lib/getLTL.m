function [fLTL,phi] = getLTL(formula,k)

[Op,args] = parseLTL(formula);

switch Op
    case 'And'
        [fLTL,phi] = getAnd(formula,args,k);
    case 'Or'
        [fLTL,phi] = getOr(formula,args,k);
    case 'Neg'
        [fLTL,phi] = getNeg(formula,args,k);
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
    otherwise
        disp('wrong formula');
end
    