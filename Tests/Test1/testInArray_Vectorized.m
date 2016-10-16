function [t,v] = testInArray_Vectorized()
    % MATLAB: 8.5.0.197613 (R2015a)

    % searching
    A = randi(1000, [500 600]);  % haystack
    x = [10,40,20,30];           % needle
    
    % compare implementations
    f = {
        @() func_eq_loop(A,x);
        @() func_eq_arrayfun(A,x);
        @() func_eq_bsxfun(A,x);
        @() func_eq_earlyexit(A,x);
        @() func_ismember(A,x)
    };

    % time and check results
    t = cellfun(@timeit, f, 'UniformOutput',true);
    v = cellfun(@feval, f, 'UniformOutput',false);
    assert(isequal(v{:}));
end


function v = func_eq_loop(A,x)
    % compare all elements of A against every value in x
    v = false(size(x));
    for j=1:numel(x)
        v(j) = any(A(:) == x(j));
    end
end

function v = func_eq_arrayfun(A,x)
    % use ARRAYFUN instead of an explicit loop
    v = arrayfun(@(xx) any(A(:) == xx), x);
end

function v = func_eq_bsxfun(A,x)
    % vectorized BSXFUN call
    % (the downside is that it creates a large intermediate matrix)
    %assert(isrow(x))
    v = any(bsxfun(@eq, A(:), x), 1);
end

function v = func_eq_earlyexit(A,x)
    % nested loops (with early-exit)
    v = false(size(x));
    for j=1:numel(x)
        for i=1:numel(A)
            if A(i) == x(j)
                v(j) = true;
                break;
            end
        end
    end
end

function v = func_ismember(A,x)
    % ISMEMBER
    v = ismember(x,A);
end
