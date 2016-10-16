function uTest_anyEq(doSpeed)
% Unit test: anyEq
% This is a routine for automatic testing. It is not needed for processing and
% can be deleted or moved to a folder, where it does not bother.
%
% uTest_anyEq(doSpeed)
% INPUT:
%   doSpeed: If ANY(doSpeed) is TRUE, the speed is measured. Optional.
% OUTPUT:
%   On failure the test stops with an error.
%
% Tested: Matlab 6.5, 7.7, 7.8, 7.13, WinXP/32, Win7/64
% Author: Jan Simon, Heidelberg, (C) 2009-2013 matlab.THISYEAR(a)nMINUSsimon.de

% $JRev: R-m V:012 Sum:asN0o9vK7lMu Date:09-Sep-2013 01:58:40 $
% $License: BSD (use/copy/change/redistribute on own risk, mention the author) $
% $File: Tools\UnitTests_\uTest_anyEq.m $

% Initialize: ==================================================================
% Global Interface: ------------------------------------------------------------
ErrID = ['JSimon:', mfilename];

% Initial values: --------------------------------------------------------------
LF = char(10);

% Program Interface: -----------------------------------------------------------
if nargin == 0
   doSpeed = true;
end

if doSpeed
   randTestTime = 0.5;  % Time for random tests
else
   randTestTime = 0.2;  % Time for random tests
end

% User Interface: --------------------------------------------------------------
% Do the work: =================================================================
disp(['==== Test anyEq  ', datestr(now, 0)]);
disp(['  Version: ', which('anyEq')]);
pause(0.01);  % Flush events

ClassList = {'int8', 'uint8', 'int16', 'uint16', 'int32', 'uint32', ...
   'int64', 'uint64', 'double', 'single', 'char', 'logical'};

% No int64 in Matlab 6.5:
if sscanf(version, '%d', 1) < 7   % I don't know when INT64 was working
   ClassList(strcmp(ClassList, 'int64'))  = [];
   ClassList(strcmp(ClassList, 'uint64')) = [];
end

for iClass = 1:length(ClassList)
   aClass = ClassList{iClass};
   disp([upper(aClass), ':']);
   
   % Empty inputs:
   if isequal(anyEq(cast([], aClass), cast([], aClass)), false)
      hidedisp('  ok: [], []');
   else
      error(ErrID, 'anyEq: Failed for: [], []');
   end
   
   if isequal(anyEq(cast([], aClass), cast(1, aClass)), false)
      hidedisp('  ok: [], [1]');
   else
      error(ErrID, 'anyEq: Failed for: [], [1]');
   end
   
   if isequal(anyEq(cast(1, aClass), cast([], aClass)), false)
      hidedisp('  ok: [1], []');
   else
      error(ErrID, 'anyEq: Failed for: [1], []');
   end
   
   if isequal(anyEq(cast([], aClass), cast(0:1, aClass)), false)
      hidedisp('  ok: [], [0, 1]');
   else
      error(ErrID, 'anyEq: Failed for: [], [0, 1]');
   end
   
   if isequal(anyEq(cast(0:1, aClass), cast([], aClass)), false)
      hidedisp('  ok: [0, 1], []');
   else
      error(ErrID, 'anyEq: Failed for: [0, 1], []');
   end
   
   % Both inputs have elements:
   if isequal(anyEq(cast(zeros(1, 4), aClass), cast(1, aClass)), false)
      hidedisp('  ok: [0,0,0,0], [1]');
   else
      error(ErrID, 'anyEq: Failed for: [0,0,0,0], [1]');
   end
   
   if isequal(anyEq(cast(ones(1, 4), aClass), cast(0, aClass)), false)
      hidedisp('  ok: [1,1,1,1], [0]');
   else
      error(ErrID, 'anyEq: Failed for: [1,1,1,1], [0]');
   end
   
   if isequal(anyEq( ...
         cast(zeros(1, 4), aClass), cast(ones(1,3), aClass)), false)
      hidedisp('  ok: [0,0,0,0], [1,1,1]');
   else
      error(ErrID, 'anyEq: Failed for: [0,0,0,0], [1,1,1]');
   end
   
   if isequal(anyEq( ...
         cast(ones(1, 2), aClass), cast(zeros(1,4), aClass)), false)
      hidedisp('  ok: [1,1], [0,0,0,0]');
   else
      error(ErrID, 'anyEq: Failed for: [1,1], [0,0,0,0]');
   end
   
   if isequal(anyEq(cast(zeros(1, 4), aClass), cast(0, aClass)), true)
      hidedisp('  ok: [0,0,0,0], [0]');
   else
      error(ErrID, 'anyEq: Failed for: [0,0,0,0], [0]');
   end
   
   if isequal(anyEq(cast(ones(1, 4), aClass), cast(1, aClass)), true)
      hidedisp('  ok: [1,1,1,1], [1]');
   else
      error(ErrID, 'anyEq: Failed for: [1,1,1,1], [1]');
   end
   
   if isequal(anyEq( ...
         cast(zeros(1, 4), aClass), cast(zeros(1,3), aClass)), true)
      hidedisp('  ok: [0,0,0,0], [0,0,0]');
   else
      error(ErrID, 'anyEq: Failed for: [0,0,0,0], [0,0,0]');
   end
   
   if isequal(anyEq( ...
         cast(ones(1, 2), aClass), cast(ones(1,4), aClass)), true)
      hidedisp('  ok: [1,1], [1,1,1,1]');
   else
      error(ErrID, 'anyEq: Failed for: [1,1], [1,1,1,1]');
   end
   
   if isequal(anyEq( ...
         cast([0,0,0,1], aClass), cast([0,0,1], aClass)), true)
      hidedisp('  ok: [0,0,0,1], [0,0,1]');
   else
      error(ErrID, 'anyEq: Failed for: [0,0,0,1], [0,0,1]');
   end
   
   if isequal(anyEq( ...
         cast([1,1,1,1], aClass), cast([0,0,1], aClass)), true)
      hidedisp('  ok: [1,1,1,1], [0,0,1]');
   else
      error(ErrID, 'anyEq: Failed for: [1,1,1,1], [0,0,1]');
   end
   
   % For LOGICALs checking for different values > 1 does not work:
   if ~strcmp(aClass, 'logical')
      if isequal(anyEq(cast(1:2, aClass), cast(3, aClass)), false)
         hidedisp('  ok: [1, 2], [3]');
      else
         error(ErrID, 'anyEq: Failed for: [1, 2], [3]');
      end
      
      if isequal(anyEq(cast(1:2, aClass), cast(2, aClass)), true)
         hidedisp('  ok: [1, 2], [2]');
      else
         error(ErrID, 'anyEq: Failed for: [1, 2], [2]');
      end
      
      if isequal(anyEq(cast(1:2, aClass), cast(1, aClass)), true)
         hidedisp('  ok: [1, 2], [1]');
      else
         error(ErrID, 'anyEq: Failed for: [1, 2], [1]');
      end
      
      if isequal(anyEq(cast(1:2, aClass), cast(0, aClass)), false)
         hidedisp('  ok: [1, 2], [0]');
      else
         error(ErrID, 'anyEq: Failed for: [1, 2], [0]');
      end
      
      if isequal(anyEq(cast(3, aClass), cast(1:2, aClass)), false)
         hidedisp('  ok: [3], [1, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [3], [1, 2]');
      end
      
      if isequal(anyEq(cast(2, aClass), cast(1:2, aClass)), true)
         hidedisp('  ok: [2], [1, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [2], [1, 2]');
      end
      
      if isequal(anyEq(cast(1, aClass), cast(1:2, aClass)), true)
         hidedisp('  ok: [1], [1, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [1], [1, 2]');
      end
      
      if isequal(anyEq(cast(0, aClass), cast(1:2, aClass)), false)
         hidedisp('  ok: [0], [1, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [0], [1, 2]');
      end
      
      if isequal(anyEq(cast(1:2, aClass), cast([4, 3], aClass)), false)
         hidedisp('  ok: [1, 2], [4, 3]');
      else
         error(ErrID, 'anyEq: Failed for: [1, 2], [4, 3]');
      end
      
      if isequal(anyEq(cast(1:2, aClass), cast([4, 2], aClass)), true)
         hidedisp('  ok: [1, 2], [4, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [1, 2], [4, 2]');
      end
      
      if isequal(anyEq(cast(1:2, aClass), cast([4, 1], aClass)), true)
         hidedisp('  ok: [1, 2], [4, 1]');
      else
         error(ErrID, 'anyEq: Failed for: [1, 2], [4, 1]');
      end
      
      if isequal(anyEq(cast(1:2, aClass), cast([4, 0], aClass)), false)
         hidedisp('  ok: [1, 2], [4, 0]');
      else
         error(ErrID, 'anyEq: Failed for: [1, 2], [4, 0]');
      end
      
      if isequal(anyEq(cast([4, 3], aClass), cast(1:2, aClass)), false)
         hidedisp('  ok: [4, 3], [1, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [4, 3], [1, 2]');
      end
      
      if isequal(anyEq(cast([4, 2], aClass), cast(1:2, aClass)), true)
         hidedisp('  ok: [4, 2], [1, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [4, 2], [1, 2]');
      end
      
      if isequal(anyEq(cast([4, 1], aClass), cast(1:2, aClass)), true)
         hidedisp('  ok: [4, 1], [1, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [4, 1], [1, 2]');
      end
      
      if isequal(anyEq(cast([4, 0], aClass), cast(1:2, aClass)), false)
         hidedisp('  ok: [4, 0], [1, 2]');
      else
         error(ErrID, 'anyEq: Failed for: [4, 0], [1, 2]');
      end
      
      % Arrays:
      X = reshape(cast(1:12, aClass), 3, 4);
      if isequal(anyEq(X, cast(0, aClass)), false)
         hidedisp('  ok: 1:12 as 3x4, [0]');
      else
         error(ErrID, 'anyEq: Failed for: 1:12 as 3x4, [0]');
      end
      
      if isequal(anyEq(X, cast(1, aClass)), true)
         hidedisp('  ok: 1:12 as 3x4, [1]');
      else
         error(ErrID, 'anyEq: Failed for: 1:12 as 3x4, [1]');
      end
      
      if isequal(anyEq(X, cast(12, aClass)), true)
         hidedisp('  ok: 1:12 as 3x4, [12]');
      else
         error(ErrID, 'anyEq: Failed for: 1:12 as 3x4, [12]');
      end
      
      if isequal(anyEq(cast(0, aClass), X), false)
         hidedisp('  ok: [0], 1:12 as 3x4');
      else
         error(ErrID, 'anyEq: Failed for: [0], 1:12 as 3x4');
      end
      
      if isequal(anyEq(cast(1, aClass), X), true)
         hidedisp('  ok: [1], 1:12 as 3x4');
      else
         error(ErrID, 'anyEq: Failed for: [1], 1:12 as 3x4');
      end
      
      if isequal(anyEq(cast(12, aClass), X), true)
         hidedisp('  ok: [12], 1:12 as 3x4');
      else
         error(ErrID, 'anyEq: Failed for: [12], 1:12 as 3x4');
      end
      
      if isequal(anyEq(cast(12:24, aClass), X), true)
         hidedisp('  ok: 12:24, 1:12 as 3x4');
      else
         error(ErrID, 'anyEq: Failed for: 12:24, 1:12 as 3x4');
      end
      
      if isequal(anyEq(X, cast(12:24, aClass)), true)
         hidedisp('  ok: 1:12 as 3x4, 12:24');
      else
         error(ErrID, 'anyEq: Failed for: 1:12 as 3x4, 12:24');
      end
      disp('  ok: known answer tests');
      
      % Random tests:
      iniTime = cputime;
      while cputime - iniTime < randTestTime
         X = cast(floor(rand(floor(rand(1, 3) * 10)) * 127), aClass);  % UINT8
         Y = cast(floor(rand(floor(rand(1, 3) * 10)) * 127), aClass);
         if isequal(anyEq(X, Y), localanyEq(X, Y)) == 0
            fprintf('\n');
            error(ErrID, 'anyEq: Failed for random test data.');
         end
      end
      fprintf('  ok: random test data\n');
   
   else  % Special tests for LOGICALs: -----------------------------------------
      disp('  ok: known answer tests');
            
      for k = 1:256
         % Check comparison with FALSE:
         data = true(1, k);
         if anyEq(data, false)
            error(ErrID, 'anyEq: Failed for logical array (false1).');
         end
         if ~anyEq([data, false], false)
            error(ErrID, 'anyEq: Failed for logical array (false2).');
         end
         
         % Check comparison with TRUE:
         data = false(1, k);
         if anyEq(data, true)
            error(ErrID, 'anyEq: Failed for logical array (true1).');
         end
         if ~anyEq([data, true], true)
            error(ErrID, 'anyEq: Failed for logical array (true2).');
         end
         
         % Check pattern:
         data = (dec2bin(k) == '1');
         if anyEq(data, true) ~= any(data)
            error(ErrID, 'anyEq: Failed for logical array (pattern).');
         end
      end
      fprintf('  ok: aligned data for LOGICAL\n');
   end
   
   % Check NaNs for SINGLE and DOUBLE: -----------------------------------------
   if strcmp(aClass, 'single') || strcmp(aClass, 'double')
      if isequal(anyEq(cast(1:10, aClass), cast(NaN, aClass)), false)
         hidedisp('  ok: 1:10, NaN ==> FALSE');
      else
         error(ErrID, 'anyEq: Failed for: 1:10, NaN');
      end
      
      if isequal(anyEq(cast([1:10, NaN], aClass), cast(NaN, aClass)), true)
         hidedisp('  ok: [1:10, NaN], NaN ==> TRUE');
      else
         error(ErrID, 'anyEq: Failed for: [1:10, NaN], NaN');
      end
      
      if isequal(anyEq( ...
            cast([1:10, NaN], aClass), cast([0, NaN], aClass)), true)
         hidedisp('  ok: [1:10, NaN], [0, NaN] ==> TRUE');
      else
         error(ErrID, 'anyEq: Failed for: [1:10, NaN], [0, NaN]');
      end
      fprintf('  ok: test NaN==NaN\n');
   end
end

% Check catching of bad input: -------------------------------------------------
fprintf('\n== Error handling:\n');
tooLazy = false;

try
   dummy   = anyEq;  %#ok<*NASGU>
   tooLazy = true;
catch
   disp(['  ok: No inputs rejected: ', LF, '      ', ...
      strrep(lasterr, LF, '; ')]);
end
if tooLazy
   error(ErrID, 'No inputs not rejected.');
end

try
   dummy   = anyEq(ones(1, 2));
   tooLazy = true;
catch
   disp(['  ok: 1 input rejected: ', LF, '      ', ...
      strrep(lasterr, LF, '; ')]);
end
if tooLazy
   error(ErrID, '1 input not rejected.');
end

try
   dummy   = anyEq(ones(1, 2), 1, 2);
   tooLazy = true;
catch
   disp(['  ok: 3 inputs rejected: ', LF, '      ', ...
      strrep(lasterr, LF, '; ')]);
end
if tooLazy
   error(ErrID, '3 inputs not rejected.');
end

try
   dummy   = anyEq({1}, {2, 3});
   tooLazy = true;
catch
   disp(['  ok: Bad input type rejected: ', LF, '      ', ...
      strrep(lasterr, LF, '; ')]);
end
if tooLazy
   error(ErrID, 'Bad input type not rejected.');
end

try
   dummy   = anyEq(int32(1:10), 1:10);
   tooLazy = true;
catch
   disp(['  ok: Different input types rejected: ', LF, '      ', ...
      strrep(lasterr, LF, '; ')]);
end
if tooLazy
   error(ErrID, 'Different input types not rejected.');
end

% Find a suiting number of loops: ----------------------------------------------
fprintf('\n== Test speed for DOUBLE:\n');
pause(0.01);       % Take time to check for Ctrl-C...
LenExpList = 2:7;  % Test data length as 10^LenExpList
fprintf('  #loops => get about 1 sec processing time\n');

for SearchLen = [1, 2, 4, 8]
   fprintf('No match (worst case), Y=[%d x 1]:\n', SearchLen);
   fprintf('  X:          #loops:   anyEq:     ANY(X==Y):\n');
   for LenExp = LenExpList
      Len = 10 ^ LenExp;
      X   = rand(Len, 1);
      Y   = rand(SearchLen,  1) + 2;  % X and Y do not share values
      nLoops = GetNLoops(X, Y, doSpeed);
      
      switch SearchLen
         case 1
            tic;
            for i = 1:nLoops
               E = any(X == Y);
               clear('E');
            end
            MT = toc + eps;
         case 2
            tic;
            for i = 1:nLoops
               E = any(X == Y(1)) || any(X == Y(2));
               clear('E');
            end
            MT = toc + eps;
         case 4
            tic;
            for i = 1:nLoops
               E = any(X == Y(1)) || any(X == Y(2)) || any(X == Y(3)) ...
                  || any(X == Y(4));
               clear('E');
            end
            MT = toc + eps;
         case 8
            tic;
            for i = 1:nLoops
               E =   any(X == Y(1)) || any(X == Y(2)) || any(X == Y(3)) ...
                  || any(X == Y(4)) || any(X == Y(5)) || any(X == Y(6)) ...
                  || any(X == Y(7)) || any(X == Y(8));
               clear('E');
            end
            MT = toc + eps;
      end
      
      tic;
      for i = 1:nLoops
         E = anyEq(X, Y);
         clear('E');
      end
      MexT = toc;
      
      p = 100 * MexT / MT;
      if p > 1
         fprintf('  [1E%d x 1]: %8d  %5.2f sec  %5.2f sec   ==>  %.2f%%\n', ...
            LenExp, nLoops, MexT, MT, p);
      else
         fprintf('  [1E%d x 1]: %8d  %5.2f sec  %5.2f sec   ==>  %.4g%%\n', ...
            LenExp, nLoops, MexT, MT, p);
      end
   end
end

fprintf('\n1st element matching (best case), Y=X(1):\n');
fprintf('  X:          #loops:  anyEq:        ANY(X==Y):\n');
for LenExp = LenExpList
   Len = 10 ^ LenExp;
   X   = rand(Len, 1);
   Y   = X(1);
   nLoops = GetNLoops(X, Y, doSpeed);
   
   tic;
   for i = 1:nLoops
      E = any(X == Y);
      clear('E');
   end
   MT = toc + eps;
   
   % Special treatment of really fast loop for better precision of TIC/TOC:
   factor = max(1, Len / 1000);
   tic;
   for i = 1:nLoops * factor
      E = anyEq(X, Y);
      clear('E');
   end
   MexT = toc / factor;
   
   p = 100 * MexT / MT;
   if p > 1
      fprintf('  [1E%d x 1]: %8d  %7.5f sec  %5.2f sec   ==>  %.2f%%\n', ...
         LenExp, nLoops, MexT, MT, p);
   else
      fprintf('  [1E%d x 1]: %8d  %7.5f sec  %5.2f sec   ==>  %.4g%%\n', ...
         LenExp, nLoops, MexT, MT, p);
   end
end

fprintf('\nLOGICAL array (worst case):\n');
fprintf('  X:          #loops:  anyEq:        ANY(X):\n');
for LenExp = LenExpList
   Len = 10 ^ LenExp;
   X   = false(Len, 1);
   Y   = true;
   nLoops = GetNLoops(X, Y, doSpeed);
   
   tic;
   for i = 1:nLoops
      E = any(X);
      clear('E');
   end
   MT = toc + eps;
   
   tic;
   for i = 1:nLoops
      E = anyEq(X, Y);
      clear('E');
   end
   MexT = toc;
   
   p = 100 * MexT / MT;
   if p > 1
      fprintf('  [1E%d x 1]: %8d  %7.5f sec  %5.2f sec   ==>  %.2f%%\n', ...
         LenExp, nLoops, MexT, MT, p);
   else
      fprintf('  [1E%d x 1]: %8d  %7.5f sec  %5.2f sec   ==>  %.4g%%\n', ...
         LenExp, nLoops, MexT, MT, p);
   end
end


% Goodbye:
fprintf('\n== anyEq passed the tests.\n');

% return;

% ******************************************************************************
function nLoops = GetNLoops(X, Y, doSpeed)
% Get number of iterations for valid speed measurement:

if doSpeed
   iLoop     = 0;
   startTime = cputime;
   while cputime - startTime < 0.5
      E     = localanyEq(X, Y);  %#ok<NASGU*>
      clear('E');
      iLoop = iLoop + 1;
   end
   nPerSec = ceil(2 * iLoop / (cputime - startTime));
   
   % Round loop numbers:
   nDigits = max(1, floor(log10(max(1, nPerSec))) - 1);
   nLoops  = max(4, round(nPerSec / 10 ^ nDigits) * 10 ^ nDigits);
   % nLoops  = max(4, nPerSec);
else
   nLoops = 10;  % Minimal tests
end

% return;

% ******************************************************************************
function hidedisp(Str)  %#ok<INUSD>
% Uncomment this, if you want to see all successful tests:
% disp(Str);
% return;

% ******************************************************************************
function E = localanyEq(X, Y)
% Pure Matlab function for testing. This is always slower than the direct
% ANY(X==Y(i)) approach.

X = X(:);
for i = 1:numel(Y)
   if any(X == Y(i))  % Linear indexing, works also if Y is an array
      E = true;
      return;
   end
end

E = false;

% return;
