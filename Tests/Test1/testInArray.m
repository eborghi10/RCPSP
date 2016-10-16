function [t,v] = testInArray()
    % MATLAB: 8.5.0.197613 (R2015a)

    % searching
    A = randi(1000, [500 600]);  % haystack
    x = 10;                      % needle
    
    % compare implementations
    f = {
        @() func_eq(A,x);
        @() func_eq_earlyexit(A,x);
        @() func_ismember(A,x)
    };

    % time and check results
    t = cellfun(@timeit, f, 'UniformOutput',true);
    v = cellfun(@feval, f, 'UniformOutput',true);
    assert(all(diff(v)==0));
end


function v = func_eq(A,x)
    % compare all elements of A against x
    v = any(A(:) == x);
end

function v = func_eq_earlyexit(A,x)
    % loop (with early-exit)
    v = false;
    for i=1:numel(A)
        if A(i) == x
            v = true;
            return;
        end
    end
end

function v = func_ismember(A,x)
    % ISMEMBER
    v = ismember(x,A);
end
