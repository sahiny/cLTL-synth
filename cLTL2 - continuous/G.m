function phi = G(varargin)
% Returns a polytope
assert(nargin == 1, 'G takes one variable');
% Returns a polytope
if strcmp(varargin{1}.type, 'inner') || strcmp(varargin{1}.type, 'ap')
    phi = struct('type', 'inner', 'Op', 'G', 'args', {varargin}, ...
        'formula', strcat('G(', varargin{1}.formula, ')'));
else
    phi = struct('type', 'outer', 'Op', 'G', 'args', {varargin}, ...
        'formula', strcat('G(', varargin{1}.formula, ')'));   
end
