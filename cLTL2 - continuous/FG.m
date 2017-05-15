%
% ( RETURN_VARIABLE = FUNCTION_NAME(PARAMETER_1, PARAMETER_2, ETC)  )
%
% Author:  YOUR FULL NAME AND CADE EMAIL ADDRESS
% Date:    THE CURRENT DATE
% Partner: THE FULL NAME AND CADE EMAIL ADDRESS OF ANYONE YOU WORKED WITH
% Course:  Computer Science 1000
%
% Function Description:
%
% ( THIS FUNCTION DOES THE FOLLOWING (WRITE WHAT THE SPECIFIC GOAL OF THIS
%   SINGLE FUNCTION IS (_NOT_ WHAT THE GOAL OF THE ENTIRE PROGRAM IS).  THIS
%   DESCRIPTION SHOULD BE IN HIGH LEVEL ENGLISH AND MAY CONTAIN A LIST OF
%   STEPS (E.G.,:
%     1) DO THIS
%     2) THEN DO THIS
%     3) CALCULATE THAT
%     4) RETURN THE FINAL VALUE AS RETURN_VARIABLE)
%  )
%
%
% Input Parameters: (LIST ALL THE PARAMETERS TO THE FUNCTION (OR SAY
%                     NONE IF THERE ARE NO INPUT PARAMETERS)
%
%         PARAMETER_1: Name, Type, Purpose
%         PARAMETER_2: Name, Type, Purpose
%         PARAMETER_3: Name, Type, Purpose
%         ETC
%
% Returned Value: (LIST THE DATA THAT IS _RETURNED_ BY THIS FUNCTION.
%                  PLEASE NOTE THAT DATA PRINTED TO THE SCREEN IS _NOT_
%                  RETURNED.  THERE IS A SPECIFIC DIFFERENCE BETWEEN
%                  THINGS PRINTED TO THE SCREEN AND THOSE RETURNED )
%
%         Returned_Variable_1: Name, Type, Purpose
%         ETC
%
% Algorithm: (ADD ANY ADDITIONAL NOTES YOU HAVE ABOUT THE FUNCTION
%             HERE, INCLUDING HOW THE DATA IS PROCESSED OR WHAT
%             KIND OF DATA STRUCTURES YOU MAY USE)
%
%
% Examples of Use:
%
%     (SHOW HOW TO CALL THE FUNCTION)
%


function phi = FG(varargin)
% Returns a polytope
assert(nargin == 1, 'FG takes one variable');
% Returns a polytope
if strcmp(varargin{1}.type, 'inner') || strcmp(varargin{1}.type, 'ap')
    phi = struct('type', 'inner', 'Op', 'FG', 'args', {varargin}, ...
        'formula', strcat('FG(', varargin{1}.formula, ')'));
else
    phi = struct('type', 'outer', 'Op', 'FG', 'args', {varargin}, ...
        'formula', strcat('FG(', varargin{1}.formula, ')'));   
end