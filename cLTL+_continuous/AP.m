function [ap, ap_cell] = AP(A, b, ap_cell)
%
% Returns a struct representing an atomic proposition
%   type:       'ap'
%   Op:         'AP'
%   formula:    formula in string form
%   args:       arguments are also inner formulas or ap
%
% A,b:  Polytope given by Ax<=b
% Op: AP
% formula: apX where X is an integer which is assigned automatically
%

% Create ap
assert(isnumeric(A), isnumeric(b), 'A and b must be numeric');
assert(size(A,1) == size(b,1), 'A and b must have same number of rows')
ap = struct('type', 'inner', 'A', A, 'b', b, 'Op', 'AP', ...
    'formula', strcat('ap', num2str(length(ap_cell)+1)));
ap.args = {ap};

% add it to ap_list to keep track
ap_cell{length(ap_cell)+1} = ap;


