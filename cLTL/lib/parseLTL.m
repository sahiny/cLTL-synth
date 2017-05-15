function [Op,arguments] = parseLTL(formula)
% Returns Operator and arguments
if ~ischar(formula)
   Op = 'And';
   arguments = {formula};
   return
end

%formula = formula(find(~isspace(formula)));

% Temporal operators
Op_list = {'G','F','X','FG','GF','GG','FF'};

% Index of first '('
i = strfind(formula,'(');
if isempty(i)
    Op = 'And';
    arguments = {str2num(formula)};
    return
else
    i=i(1);
end
% Index of last ')'
j = strfind(formula,')');j=j(end);

% Big Operator
Op = formula(1:i-1);

% Now find arguments
formula2 = formula(i+1:j-1);

if any(ismember(Op_list,Op)) 
    
    % index of first occurence '['
    ap_index = strfind(formula2,'[');ap_index = ap_index(1);
    % index of first occurence '('
    phi_index = strfind(formula2,'(');
    if isempty(phi_index)
        phi_index = inf;
    else 
        phi_index = phi_index(1);
    end
    if ap_index < phi_index
        arguments= {str2num(formula2)};
    else
        arguments = {formula2};
    end
    return
else
    arguments = {};
end

lcount = 0;
rcount = 0;

while ~isempty(formula2)
    % index of first occurence '['
    ap_index = strfind(formula2,'[');ap_index = ap_index(1);
    % index of first occurence '('
    phi_index = strfind(formula2,'(');
    if isempty(phi_index)
        phi_index = inf;
    else 
        phi_index = phi_index(1);
    end

    if ap_index < phi_index
        lbracket = '[';
        rbracket = ']';
    else
        lbracket = '(';
        rbracket = ')';
    end
    
    for i=1:length(formula2)
        if formula2(i) == lbracket
            lcount = lcount + 1;
        elseif formula2(i) == rbracket
            rcount = rcount + 1;
            if lcount == rcount
                if ap_index < phi_index
                    arguments{end+1} = str2num(formula2(1:i));
                else
                    arguments{end+1} = formula2(1:i);
                end
                formula2 = formula2(i+2:end);
                break
            end
        end
    end
end

   


