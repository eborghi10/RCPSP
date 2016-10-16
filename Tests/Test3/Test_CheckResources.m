ES = 1;
LS = 4;
T = 10000;
K = 20;
Res = randi(50);
Rk = repmat(K,1,T);

%% VERSION 1
tic;
Ret = 0;
if all(Res <= Rk([ES:LS]+1))
    Ret = 1;
end
toc;

%% VERSION 2
tic;
Ret = 1;
for t = ES:1:LS
    if Res > Rk(t+1)
        Ret = 0;
        break;
    end
end
toc;

%% VERSION 3
tic;
dur = ES:LS;
Ret = ~any(any(repmat(Res,1,length(dur))>Rk(:,dur+1)));
toc;