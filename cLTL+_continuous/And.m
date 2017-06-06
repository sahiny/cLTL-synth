function phi = And(varargin)
%
% Returns a struct representing the formula
%   type:       Inner,Outer
%   Op:         'And'
%   formula:    formula in string form
%   args:       arguments are also inner formulas or ap
%

formula = strcat('And(', varargin{1}.formula);
if strcmp(varargin{1}.type, 'inner')|| strcmp(varargin{1}.type, 'ap')
    for i = 2:nargin
        assert(strcmp(varargin{i}.type, 'inner') || ...
            strcmp(varargin{i}.type, 'ap'), ...
            'Inner and outer logic formulas cannot be mixed');
        formula = strcat(formula, ', ', varargin{i}.formula);
    end
    
    formula = strcat(formula, ')');
    phi = struct('type', 'inner', 'Op', 'And', ...
        'formula', formula, 'args', {varargin});
else
    for i = 2:nargin
        assert(strcmp(varargin{i}.type, 'outer') || ...
            strcmp(varargin{i}.type, 'tcp'), ...
            'Inner and outer logic formulas cannot be mixed');
        formula = strcat(formula, ', ', varargin{i}.formula);
    end
    
    formula = strcat(formula, ')');
    phi = struct('type', 'outer', 'Op', 'And', ...
        'formula', formula, 'args', {varargin});    
end
