% IS_MEMBER() PERFORMANCE TEST
%%
% PROBAR PERFORMANCE USANDO TODAS LAS FUNCIONES EN SCRIPTS DIFERENTES Y
% USAR timeit().
%%
%clear;
%clc;
function Test_IsMember()
    I = randi(1000,[1 1000]);
    C = randi(1000,[1 500]);
    i = single(I);
    c = single(C);
    n = size(I,2);

    f1(I,C);
    f2(i,c);
%    f3(I,C);
%    f4(i,c);
    f5(I,C,n);
    f6(i,c,n);
    f7(I,C,n);
    f8(i,c,n);
    f9(I,C,n);
    f10(i,c,n);
%    f11(I,C);
%    f12(i,c);
    f13(I,C);
    f14(I,C);
    MY_intersect(I,C);
end
%% #1
%tic;
function f1(I,C)
    ismember(I,C);
end
%toc;
%% #2
%tic;
function f2(i,c)
    ismember(i,c);
end
%toc;
%% #3
%tic;
function f3(I,C)
    ismember(I,C,'legacy');
end
%toc;
%% #4
%tic;
function f4(i,c)
    ismember(i,c,'legacy');
end
%toc;
%% #5
%tic;
function f5(I,C,n)
    b = zeros(1,n);
    for cc = 1:numel(C)
        b = b + ismembc(I,C(cc));
    end
end
%toc;
%% #6
%tic;
function f6(i,c,n)
    b = zeros(1,n);
    for cc = 1:numel(c)
        b = b + ismembc(i,c(cc));
    end
end
%toc;
%% #7
%tic;
function f7(I,C,n)
    b = zeros(1,n);
    for cc = 1:numel(C)
        b = b + ismembc2(I,C(cc));
    end
end
%toc;
%% #8
%tic;
function f8(i,c,n)
    b = zeros(1,n);
    for cc = 1:numel(c)
        b = b + ismembc2(i,c(cc));
    end
end
%toc;
%% #9
%tic;
function f9(I,C,n)
    d = zeros(1,n);
    for cc = 1:numel(C)
        d = d + I==C(cc);
    end
end
%toc;
%% #10
%tic;
function f10(i,c,n)
    d = zeros(1,n);
    for cc = 1:numel(c)
        d = d + i==c(cc);
    end
end
%toc;
%% #11
%tic;
function f11(I,C)
    setdiff(I,C);
end
%toc;
%% #12
%tic;
function f12(i,c)
    setdiff(i,c);
end
%toc;
%% #13
%tic;
function f13(I,C)
    [~,z] = ismember(I,C);
    z(~z) = [];
end
%toc;
%% #14
%tic;
function f14(I,C)
    ismember(single(I),single(C));
end
%toc;
%% #15
function C = MY_intersect(A,B)
    if ~isempty(A)&&~isempty(B)
     P = zeros(1, max(max(A),max(B)) ) ;
     P(A) = 1;
     C = B(logical(P(B)));
    else
      C = [];
    end
end