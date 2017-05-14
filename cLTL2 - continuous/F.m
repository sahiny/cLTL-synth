function phi = F(varargin)
% Returns a polytope
assert(nargin == 1, 'F takes one variable');
% Returns a polytope
if strcmp(varargin{1}.type, 'inner') || strcmp(varargin{1}.type, 'ap')
    phi = struct('type', 'inner', 'Op', 'F', 'args', {varargin}, ...
        'formula', strcat('F(', varargin{1}.formula, ')'));
else
    phi = struct('type', 'outer', 'Op', 'F', 'args', {varargin}, ...
        'formula', strcat('F(', varargin{1}.formula, ')'));   
end
