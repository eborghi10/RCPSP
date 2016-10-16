function [ Cmax, Rk ] = MakeSpan( RCPSP, I )
% Basado en SerialSGS() para calcular el makespan de soluciones viables.
    % SerialSGS() se encargó de ordenar las soluciones para que sean
    % viables repecto a la precedencia. Por esta razón, este parámetro no
    % debe ser tenido en cuenta. Solo se deben posicionar las tareas en el
    % tiempo para que cumpla la condición de "recurso máximo".

n = single(RCPSP.n);% Cantidad de actividades
d = single(RCPSP.d);% Tiempo de procesamiento de cada actividad
K = single(RCPSP.K);% Cantidad máxima de stock por cada recurso
r = RCPSP.r;        % Consumo de recursos de cada tarea
N = single(RCPSP.N);% Precedence Constraints

T = single(sum(d)); % Tiempo total que se consumiría en el peor caso
ES = zeros(1,n+1);    % Earliest Start Time
LS = zeros(1,n+1);    % Lastest Start Time

Rk = repmat(K,1,T);

I = [1 srk2al(I)+1 n+2];
%%
I = single(I);
i = I(2:end-1);

D = single( i );
for mu = 1:n
    [j,D] = seleccionarSiguienteTarea(D,i,'FIFOenI'); 
    h = single(find(N(j,:)));
    ES(j) = max(ES(h) + d(h));
    [ES(j), LS(j)] = checkResources(ES(j), d(j), r(:,j), Rk);
    dur = ES(j)+1:LS(j);
    Rk(:,dur) = Rk(:,dur) - repmat(r(:,j),1,length(dur));
end
Cmax = max(LS);
end

%% CHECK RESOURCES
function [ES,LS] = checkResources(ES,d,Res,Rk)
% Verifica que la tarea 'j' "encaje" entre [ES;LS) cumpliendo con la
% condición de los recursos.
% Retorna 0 si se produce un cambio.
% Por defecto retorna 1 (ok).
dur = ES:ES+d-1;
n = 1;
while any(any(repmat(Res,[1 numel(dur+n)]) > Rk(:,dur+n)))
    n = n + 1;
end
ES = ES + n - 1;
LS = ES + d;
end

%% SELECCIONAR SIGUIENTE TAREA
function [j,D] = seleccionarSiguienteTarea(D,i,str)
% Priority Rule-Based Heuristics
% "Handbook of Recent Advances in Scheduling" - Kolisch [1999]
% " HEURISTIC ALGORITHMS FOR SOLVING THE RESOURCE-CONSTRAINED PROJECT
% SCHEDULING PROBLEM: CLASSIFICATION AND COMPUTATIONAL ANALYSIS"
if strcmp(str,'FIFO')
    j = D(1);
    D(1) = [];
elseif strcmp(str,'FIFOenI')
    j = i(ismember(i,D));
    j = j(1);
    D(D == j) = [];
else
    j = D(1);
    D(1) = [];
end
end