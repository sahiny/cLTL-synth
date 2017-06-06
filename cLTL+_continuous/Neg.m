function phi = Neg(varargin)
assert(nargin == 1, 'Neg takes one variable');
if strcmp(varargin{1}.type, 'inner') || strcmp(varargin{1}.type, 'ap')
    phi = struct('type', 'inner', 'Op', 'Neg', 'args', {varargin}, ...
        'formula', strcat('Neg(', varargin{1}.formula, ')'));
else
    phi = struct('type', 'outer', 'Op', 'Neg', 'args', {varargin}, ...
        'formula', strcat('Neg(', varargin{1}.formula, ')'));   
end
