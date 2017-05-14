function phi = GG(varargin)
% Returns a polytope
assert(nargin == 1, 'GG takes one variable');
% Returns a polytope
if strcmp(varargin{1}.type, 'inner') || strcmp(varargin{1}.type, 'ap')
    phi = struct('type', 'inner', 'Op', 'GG', 'args', {varargin}, ...
        'formula', strcat('GG(', varargin{1}.formula, ')'));
else
    phi = struct('type', 'outer', 'Op', 'GG', 'args', {varargin}, ...
        'formula', strcat('GG(', varargin{1}.formula, ')'));   
end