function [ Z ] = SerialSGS( RCPSP, I, Graficar )
% Algoritmo: Kolisch 2015 p.9
% Datos: Kolisch 1999

n = single(RCPSP.n);% Cantidad de actividades
d = single(RCPSP.d);% Tiempo de procesamiento de cada actividad
K = single(RCPSP.K);% Cantidad máxima de stock por cada recurso
r = RCPSP.r;        % Consumo de recursos de cada tarea
N = single(RCPSP.N);% Precedence Constraints

T = single(sum(d)); % Tiempo total que se consumiría en el peor caso
ES = zeros(1,n+1);    % Earliest Start Time
LS = zeros(1,n+1);    % Lastest Start Time

R = size(K,1);      % Cantidad máxima de recursos
Rk = repmat(K,1,T);

I = [1 srk2al(I)+1 n+2];
%%
I = single(I);
i = I(2:end-1);

%% STEP #1
% Lista de actividades scheduleadas (realizadas/completadas)
C = 1;
D = single( [] );
[pred(:,1), pred(:,2)] = find(N(i,:));
%% STEP #2
for mu = 1:n
    %% STEP #3
    % Actualiza la lista que guarda las actividades que SON ELEGIBLES.
    % Condiciones para ser elegibles:
    % 1) No estar en C.
    % 2) Que sus predecesores estén en C.
    % Verifico qué predecesores están en 'C'
    V = ismembc(single(pred(:,2)),single(sort(C)));
    % El for() está para evitar que una tarea sea puesta en 'D' sin que
    % todos sus predecesores se hayan scheduleado.
    w = false(size(V));
    for p = unique(pred(:,1)','stable')
        % Analiza los predecesores de una única tarea
        v = pred(:,1) == p;
        if all(V(v))
            % Si todos los predecesores fueron scheduleados...
            % Los agrega a 'D' (cumplen las 2 condiciones)
            D = [ D, i(p) ];
            w = w | v;
        end
    end
    % Elimino los predecesores para que no vuelvan a ser elegidos
    pred(w,:) = [];
    %% STEP #4
    % Selecciono la primera actividad 'j' pendiente de la lista 'D'.
    [j,D] = seleccionarSiguienteTarea(D,i,'FIFOenI');    
    %% STEP #5
    % Obtiene el máximo tiempo de finalización de los predecesores de J
    h = single(find(N(j,:)));
    % Guarda los {Sh + Ph} correspondientes al sucesor 'j'
    % Se toma como inicio de la tarea 'j' a la tarea predecesora que
    % mayor tiempo tarda en finalizar.
    ES(j) = max(ES(h) + d(h)); % Lastest Start Time
    %% STEP #6
    % Se agrega a la solución en la posición donde se cumpla con la
    % condición de recursos máximos.
    [ES(j), LS(j)] = checkResources(ES(j), d(j), r(:,j), Rk);
        
    % Actualizo Rk:
    dur = ES(j)+1:LS(j);  % [ES;LS)
    Rk(:,dur) = Rk(:,dur) - repmat(r(:,j),1,length(dur));
    
    %% STEP #7
    % Agregar la actividad 'j' a la lista 'C'.
    C = [ C , j ];
end
% STEP #8
[~,a] = sort(ES(2:end));
Z.Sol = a;
Z.Cmax = max(LS);
Z.Rk = Rk;

if Graficar
    % Proceso Final
    DibujarSolucion(ES(2:end),LS(2:end),R,r,K,d(2:end-1));
    % RESOURCE-UTILISATION RATIO
    hold off;
    ruGraph(RUR(RCPSP,Z.Rk,Z.Cmax), Z.Cmax);
end
end

%%
function [y] = A(ES,LS,Y,t,R,K)
% TODO: REDUCIR LA CANTIDAD DE ARGUMENTOS QUE SE LE PASAN A A().
% Retorna a qué altura 'y' debe colocarse la tarea 'j' en el tiempo 't'.
y = [];
T = (ES <= t) & (LS > t);
% Hay tareas colocadas en el instante 't'?
yy = Y(T,:);
%yy(ismember(yy, [0 0], 'rows'),:) = [];
% TODO: ME PUEDO AHORRAR LA FUNCIÓN, SI SÉ QUE TAREA ESTOY COLOCANDO.
% TENGO QUE: T(j) = 0, ANTES DE PASARLA A 'yy'.
yy(all(bsxfun(@eq, yy, [0 0]), 2),:) = [];
if any(yy)
    % Por lo menos una tarea fue scheduleada
    for r = 0:K-R
        if yy <= r
% TODO: VER PARA QUE TRABAJEN LAS DOS CONDICIONES JUNTAS
            y = r;
            break;
        elseif R <= yy(:,1)
            y = r;
            break;
        end
    end
    if isempty(y)
        % Es necesario hacer una corrección
        y = -1;
    end
else
    y = 0;
end
end

function [Y] = MoverTareas(ES,LS,Y,t,R,j)
% En caso de no poder colocar una tarea, las que interfieren deben moverse.
% Para ello, debo modificar la matriz 'Y'.

%{
% EJEMPLO:
% - Tengo 3 tareas colocadas, y tengo que poner otra [13 11 16] + [18].
% - Pruebo colocándola al principio: [(18) 13 11 16].
% - Usando MOVIMIENTO ITERATIVO HACIA EL ORIGEN (Recursividad) pruebo que
se cumpla la condición de máximo recurso. Esto quiere decir, que al mover
las tareas, no deben superar el límite de consumo instantáneo.
% - Si no se cumple, debo seguir probando alternativas, o sea, cambiar la
tarea a colocar de posición: [13 (18) 11 16], [13 11 (18) 16]. En alguna de
las posibles combinaciones debería cumplirse la condición de límite máximo.

% NOTA: Para evitar movimientos, si hay un espacio entre la tarea 13 y 11,
no será necesario poner la tarea antes de 13 porque, por algún motivo, está
ese espacio. Entonces, debería comenzar a probarse: [13 (18) 11 16].
%}
yy = [];    % SOLUCIONA ERROR!!
% T: Tareas ya colocadas
T = (ES <= t) & (LS > t);
% Borra las tareas con tiempo 0 (no scheduleadas);
T = T & ~all(bsxfun(@eq, Y, [0 0 0 0]), 2)';
T(j-1) = 0;
% Buscar si hay un espacio libre entre las tareas 'T'.
% Busco donde está el cero (tarea que comienza abajo de todo). Si no
% existe, es porque hay un espacio al principio. Por ende, se puede
% comenzar colocando la tarea nueva en esta posición.
% S: Tareas scheduleadas
[S,idx] = sortrows(Y(T,2:3));
% s: Valor Final de la tarea scheduleada al principio
s = S(S(:,1) == 0,2);
for p = 1:numel(S(:,1))
% TODO: EN CASO QUE HAYA QUE COLOCAR LA TAREA ENCIMA DE TODO, VER QUE NO
% HAGA FALTA RECORRER UNA VUELTA DEL for() SIN NECESIDAD.
    if ~isempty(s)
        % Tengo que seguir buscando un espacio...
        s = S(S(:,1) == s,2);
    else
        if p > 1
            % Posiciones que no se mueven
            ind = S(:,2) <= S(p-1,2);
            % Le asigno una posición a la tarea
            yy = S(p-1,2) + [0 R];
            % Muevo las tareas
            S(~ind,:) = S(~ind,:) + R - (min(S(~ind,1)) - max(S(ind,2)));
        else
            yy = [0 R];
            % Corro las tareas sólo el espacio necesario
            S = S + R - min(S(:,1));
        end
        break;
%{
        if recursividad()
            % Anduvo bien el movimiento de tareas
            break;
        else
            % Something went wrong -> Todo para atrás :/
        end
%}
    end
end
% Reasigno las tareas previamente scheduleadas
S = [S(:,1) S(:,1) S(:,2) S(:,2)];
Y(T,:) = S(idx,:);
% Asigno posición a la actividad 'j'
if ~isempty(yy)
    Y(j-1,:) = [yy(:,1) yy(:,1) yy(:,2) yy(:,2)];
end
end

%% 
%{
function [EL,Y] = EspacioLibre(ES,LS,t,Y,r,J,K)
% Calcula si hay espacio libre en el instante 't'.
EL = 0;
ind = (ES <= t) & (LS > t);
yy = Y(ind,2:3);
yy(all(bsxfun(@eq, yy, [0 0]), 2),:) = [];
if ~isempty(yy)
    %% Calculo la distancia
    dist = [];
    [S,idx] = sortrows(yy);
    % SIEMPRE S(:) viene de a números pares
    s = numel(S);
    for i = 1:2:s
        % El primer intervalo está formado por los primeros dos números
        % excepto que S(i+1)|i=1 == S(i)|i=2 -> El último número sea igual
        % al próximo. En este caso, el intervalo continúa.
% TODO...
    end
    %% SI PASA LOS FILTROS...
    % Si hay una tarea scheduleada en el medio, me fijo si las
    % tareas entran directamente sin tener que usar MoverTareas().
    if ismember(dist,r(J(ind)))
        % Entran perfectamente
        EL = 1;
% TODO: ASIGNAR POSICIONES CORRECTAMENTE
    end
end
end
%}
%%
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

function DibujarSolucion(ES,LS,R,r,K,d)
n = size(d,2);
% Para guardar registro de las posiciones de las tareas 
Colores = (hsv(n) + ones([n 3]))/2;
% El color que está en 1, se mantiene.
% Pero el color que está en 0, pasa a 0,5.
X = [ES' LS' LS' ES'];
% 'Y' tiene el mismo tamaño que 'X' pero se le agrega la dimensión de los
% recursos
Y = zeros(n,4,R);
for st = unique(ES)
    % Tomo todas las tareas que empiezan en un tiempo 't'
    % Las selecciono en orden decreciente:
    % Primero la que más dura, así se coloca primero en el diagrama
    FT = LS(ES == st);
    % Tareas a colocar
    J = find(ES == st)+1;
    [~,ind] = sort(FT,'descend');
    % Voy colocando cada tarea
%    [EL,y] = EspacioLibre(ES,LS,st,Y,r,J,K);
%    if ~EL
        for j = ind
% TODO: AGREGAR COMPATIBILIDAD PARA VARIOS RECURSOS        
            % Debo verificar que en el tiempo inicial, no haya ninguna
            % tarea colocada previamente en cero
            for rr = 1:R
                yy = A(ES,LS,Y(:,2:3,rr),st,r(rr,J(j)),K(rr));
                if yy == -1
                    Y(:,:,rr) = MoverTareas(ES,LS,Y(:,:,rr),st,...
                        r(rr,J(j)),J(j));
                else
                    % El primer elemento se coloca en cero
                    Y(J(j)-1,:,rr) = yy + [0 0 r(rr,J(j)) r(rr,J(j))]; 
                end
            end
        end
%    else
        % Si hay espacio libre, asigno las tareas directamente en 'Y'.
%        Y = y;
%    end
end
%% GRÁFICOS
figure;
for f = 1:R
    subplot(R,1,f);
    ylim([0 K(f)]);
    ylabel(sprintf('Recurso %d',f));
    % Dibuja y rellena los recuadros
    xlim([0 max(LS)]);
    for j = 1:n
        hold on;
        if sum(diff(Y(j,:,f)))
            % Si no usa recursos de 'f', no imprime en pantalla
            fill(X(j,:),Y(j,:,f),Colores(j,:));

            % Escribe el número de la tarea en el centro
            text((ES(j)+LS(j))/2,(Y(j,1,f)+Y(j,3,f))/2,num2str(j+1),...
                'FontWeight','bold',...
                'HorizontalAlignment','center',...
                'VerticalAlignment','middle');
        end
    end
end
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
