function phi = Or(varargin)
formula = strcat('Or(', varargin{1}.formula);
if strcmp(varargin{1}.type, 'inner') || strcmp(varargin{1}.type, 'ap')
    for i = 2:nargin
        assert(strcmp(varargin{i}.type, 'inner') || ...
            strcmp(varargin{1}.type, 'ap'), ...
            'Inner and outer logic formulas cannot be mixed');
        formula = strcat(formula, ', ', varargin{i}.formula);
    end
    
    formula = strcat(formula, ')');
    phi = struct('type', 'inner', 'Op', 'Or', ...
        'formula', formula, 'args', {varargin});
else
    for i = 2:nargin
        assert(strcmp(varargin{i}.type, 'outer') || ...
            strcmp(varargin{1}.type, 'tcp'), ...
            'Inner and outer logic formulas cannot be mixed');
        formula = strcat(formula, ', ', varargin{i}.formula);
    end
    
    formula = strcat(formula, ')');
    phi = struct('type', 'outer', 'Op', 'Or', ...
        'formula', formula, 'args', {varargin});
end
