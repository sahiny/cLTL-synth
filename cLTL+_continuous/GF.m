function phi = GF(varargin)
% Returns a polytope
assert(nargin == 1, 'GF takes one variable');
% Returns a polytope
if strcmp(varargin{1}.type, 'inner') || strcmp(varargin{1}.type, 'ap')
    phi = struct('type', 'inner', 'Op', 'GF', 'args', {varargin}, ...
        'formula', strcat('GF(', varargin{1}.formula, ')'));
else
    assert(strcmp(varargin{1}.type, 'outer') || strcmp(varargin{1}.type, 'tp'))
    phi = struct('type', 'outer', 'Op', 'GF', 'args', {varargin}, ...
        'formula', strcat('GF(', varargin{1}.formula, ')'));   
end