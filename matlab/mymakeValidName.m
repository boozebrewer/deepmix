function [names, modified] = mymakeValidName(names, varargin)
%MATLAB.LANG.MAKEVALIDNAME constructs valid MATLAB identifiers from input S
%   N = MATLAB.LANG.MAKEVALIDNAME(S) returns valid identifiers, N,
%   constructed from the input S. S is specified as a string or a cell
%   array of strings. The strings in N are NOT guaranteed to be unique. 
%
%   A valid MATLAB identifier is a character string of alphanumerics and
%   underscores, such that the first character is a letter and the length
%   of the string is <= NAMELENGTHMAX. 
%   
%   MATLAB.LANG.MAKEVALIDNAME deletes whitespace characters prior to replacing
%   any characters that are not alphnumerics or underscores. If a whitespace 
%   character is followed by a lowercase letter, MATLAB.LANG.MAKEVALIDNAME 
%   converts the letter to the corresponding uppercase character.
%
%   N = MATLAB.LANG.MAKEVALIDNAME(___, PARAM1, VAL1, PARAM2, VAL2, ...) 
%   constructs valid identifiers using additional options specified by one 
%   or more Name, Value pair arguments.
%
%   Parameters include:
%
%   'ReplacementStyle'         Controls how non-alphanumeric characters 
%                              are replaced. Valid values are 'underscore', 
%                              'hex' and 'delete'.
%
%                              'underscore' indicates non-alphanumeric
%                              characters are replaced with underscores.
%
%                              'hex' indicates each non-alphanumeric 
%                              character is replaced with a corresponding 
%                              hexadecimal representation.
%
%                              'delete' indicates all non-alphanumeric
%                              characters are deleted.
%
%                              The default 'ReplacementStyle' is 
%                              'underscore'.
%
%   'Prefix'                   Prepends the name when the first character 
%                              is not alphabetical. A valid prefix must
%                              start with a letter and only contain 
%                              alphanumeric characters and underscores.
%
%                              The default 'Prefix' is 'x'.
%
%   [N, MODIFIED] = MATLAB.LANG.MAKEVALIDNAME(S, ___) also returns a
%   logical array the same size as S, MODIFIED, that denotes modified
%   strings.
%
%	Examples
%   --------
%   Make valid MATLAB identifiers from input strings
%
%		S = {'Item_#','Price/Unit','1st order','Contact'};
%       N = MATLAB.LANG.MAKEVALIDNAME(S)
%
%   returns the cell array {'Item__' 'Price_Unit' 'x1stOrder' 'Contact'}
%
%   Make valid MATLAB identifiers using specified replacement style
%
%		S = {'Item_#','Price/Unit','1st order','Contact'};
%       N = MATLAB.LANG.MAKEVALIDNAME(S, 'ReplacementStyle', 'delete')
%
%   returns the cell array {'Item_' 'PriceUnit' 'x1stOrder' 'Contact'}
%
%   See also MATLAB.LANG.MAKEUNIQUESTRINGS, ISVARNAME, ISKEYWORD, 
%            ISLETTER, NAMELENGTHMAX, WHO, STRREP, REGEXP, REGEXPREP

%   Copyright 2013 The MathWorks, Inc.

% Parse inputs
[names, replacementStyle, prefix] = parseInputs(names, varargin{:});

% Wrap the single string NAMES in a cell for algorithm convenience
isInputSingleString = ischar(names); % names is either char or cell here
if isInputSingleString
    names = {names};
end

% Make all the names valid identifiers
modified = ~cellfun(@isvarname,names);
if any(modified)
    % Get function handle to makeValid with the correct options as specified
    makeValidFcnHandle = getMakeValidFcnHandle(replacementStyle, prefix);
    
    names(modified) = cellfun(makeValidFcnHandle, names(modified), 'UniformOutput', false);
end

% Return names as a single string if it was input as one
if isInputSingleString
    names = names{1};
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%  Make Strings Valid  %%%%%%%%%%%%%%%%%%%%%%%%%%%
function makeValidFcnHandle = getMakeValidFcnHandle(replacementStyle,prefix)

invalidCharsRegExp = '[^a-zA-Z_0-9]'; % Regular expression for invalid char

    function name = replaceWithUnderscore(name)
        % Replace all invalid characters with underscores
        name = regexprep(name,invalidCharsRegExp,'_');
    end

    function name = deleteInvalidChars(name)
        % Delete all invalid characters
        name = regexprep(name,invalidCharsRegExp,'');
    end

    function name = replaceWithHex(name)
        % Compatibility for legacy GENVARNAME conversion scheme
        illegalChars = unique(name(regexp(name,invalidCharsRegExp)));
        for illegalChar = illegalChars
            if illegalChar <= intmax('uint8')
                width = 2;
            else
                width = 4;
            end
            replace = ['0x' dec2hex(illegalChar,width)];
            name = strrep(name, illegalChar, replace);
        end
    end

    function name = makeValid(name, invalidReplacementFun)
        % Remove leading and trailing whitespace and
        % replace embedded whitespace with camel/mixed casing.
        name = regexprep(name, '(?<=\S\s+)[a-z]', '${upper($0)}');
        
        name = regexprep(name,'\s*','');
        
        % Replace invalid characters as specified by ReplacementStyle
        name = invalidReplacementFun(name);
        
        % Prepend keyword with PREFIX and camel case
        if iskeyword(name)
            name = [prefix upper(name(1)) lower(name(2:end))];
        end
        
        % Insert PREFIX if the first column is non-letter
        name = regexprep(name,'^(?![a-z])', prefix, 'emptymatch', 'ignorecase');
        
        % Truncate NAME to NAMLENGTHMAX
%         name = name(1:min(length(name),namelengthmax));
    end

switch(replacementStyle)
    case 'underscore'
        makeValidFcnHandle = @(x)makeValid(x, @replaceWithUnderscore);
    case 'delete'
        makeValidFcnHandle = @(x)makeValid(x, @deleteInvalidChars);
    otherwise % replacementStyle should be 'hex'
        assert(strcmpi(replacementStyle, 'hex')); % error if not 'hex'
        makeValidFcnHandle = @(x)makeValid(x, @replaceWithHex);
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  INPUT PARSING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [names, replacementStyle, prefix] = parseInputs(names, varargin)
persistent parser
if isempty(parser)
    parser = inputParser;
    parser.FunctionName = 'matlab.lang.makeValidName';
    parser.addParameter('ReplacementStyle','underscore',@validateReplacementStyle);
    parser.addParameter('Prefix','x',@validatePrefix);
end

% Avoid error call stack into validator functions
try
    validateCandidates(names);
    if isempty(varargin)
        replacementStyle = 'underscore';
        prefix = 'x'; 
        return;
    else        
        parser.parse(varargin{:});
    end
catch ME
    throwAsCaller(ME);
end

% Get input parameters from parser object
replacementStyle = lower(parser.Results.ReplacementStyle);
prefix = parser.Results.Prefix;
end

function validateCandidates(c)
% Candidate names must be a single string or cell array of strings
if ischar(c) && (isrow(c) || isequal(c,''))
    return % candidates is a single string (potentially empty)
elseif iscellstr(c) && isVectorOrEmpty(c) && all(cellfun(@isRowOrEmpty,c(:)))
    return % candidates is a cell array of strings
else
    error(message('MATLAB:makeValidName:InvalidCandidateNames'))
end
end

function validateReplacementStyle(replacementStyle)
% ReplacementStyle can only be one of the three values
if ~(ischar(replacementStyle) && any(strcmpi(replacementStyle,{'delete','hex','underscore'})))
    error(message('MATLAB:makeValidName:InvalidReplacementStyle'));
end
end

function validatePrefix(prefix)
% Prefix itself has to be valid MATLAB identifiers
if length(prefix)>namelengthmax
    error(message('MATLAB:makeValidName:TooLongPrefix'));
elseif ~isvarname(prefix)
    error(message('MATLAB:makeValidName:InvalidPrefix'));
end
end

function tf = isRowOrEmpty(x)
% Check if X is a row or empty string literal
tf = isrow(x) || isequal(x,'');
end

function tf = isVectorOrEmpty(x)
% Check if X is a vector or empty
tf = isvector(x) || isempty(x);
end