function [fLTL,phi] = getLTL(formula,k, varargin)

global x u Z zLoop ZLoop bigM epsilon tau;


if strcmp(formula.type,'inner')
    S = varargin{1};
    switch formula.Op
        case 'AP'
            [fLTL,phi] = getAP(formula,k, S);
        case 'And'
            [fLTL,phi] = getAndInner(formula,k, S);
        case 'Or'
            [fLTL,phi] = getOrInner(formula,k, S);
        case 'Neg'
            [fLTL,phi] = getNegInner(formula,k, S);
        case 'U'
            [fLTL,phi] = getUInner(formula,k, S);
        case 'F'
            [fLTL,phi] = getFInner(formula,k, S);
        case 'G'
            [fLTL,phi] = getGInner(formula,k, S);
        case 'FF'
            [fLTL,phi] = getFFInner(formula,k, S);
        case 'FG'
            [fLTL,phi] = getFGInner(formula,k, S);
        case 'GF'
            [fLTL,phi] = getGFInner(formula,k, S);
        case 'GG'
            [fLTL,phi] = getGGInner(formula,k, S);
        otherwise
            disp('wrong formula');
    end
else
   switch formula.Op
        case 'TCP'
            [fLTL,phi] = getTCPTau2(formula,k);
        case 'And'
            [fLTL,phi] = getAndOuter(formula,k);
        case 'Or'
            [fLTL,phi] = getOrOuter(formula,k);
        case 'Neg'
            [fLTL,phi] = getNegOuter(formula,k);
        case 'U'
            [fLTL,phi] = getUOuter(formula,k);
        case 'F'
            [fLTL,phi] = getFOuter(formula,k);
        case 'G'
            [fLTL,phi] = getGOuter(formula,k);
        case 'FF'
            [fLTL,phi] = getFFOuter(formula,k);
        case 'FG'
            [fLTL,phi] = getFGOuter(formula,k);
        case 'GF'
            [fLTL,phi] = getGFOuter(formula,k);
        case 'GG'
            [fLTL,phi] = getGGOuter(formula,k);
        otherwise
            disp('wrong formula');
    end
end
    