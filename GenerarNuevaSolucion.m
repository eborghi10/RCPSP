
function qNew = GenerarNuevaSolucion(x,RCPSP)

    q = x.Eggs;
    F = x.Fitness;
    
    [p,j] = LevyFlights(F);
    Q = q(j,:);
    N = RCPSP.N;

    if p >= 0 && p <= 0.3
        qNew = Insercion(Q,N);
    elseif p > 0.3 && p <= 1
        qNew = Swap(Q,N);
    else
        error('Error al generar nueva solución');
    end
    
    % Convierte la tarea en viable
    x = SerialSGS(RCPSP,qNew,0);
    qNew = x.Sol;
end


%% SWAP
function qNew = Swap(Q,N)

% Selecciona la tarea a swapear
i = randi([1 max(Q)],1);
idxI = find(Q == i);
[Pred,Sucs] = ObtenerLimites(N,i,Q);
idxPos = BuscarIndice(Pred,Sucs,Q);
% NOTA: Esta operación no genera soluciones inviables.
if idxPos > idxI
    qNew = [Q(1:idxI-1) Q(idxPos) Q(idxI+1:idxPos-1)...
        Q(idxI) Q(idxPos+1:end)];
elseif idxPos < idxI
    qNew = [Q(1:idxPos-1) Q(idxI) Q(idxPos+1:idxI-1)...
        Q(idxPos) Q(idxI+1:end)];
else
    qNew = Q;
end
end

%% INVERSIÓN
%{
function qNew = Inversion(q,p,Niveles)
    
    qNew = q .* repmat(p,[1 size(q,2)]);
%    qNew = zeros(size(q));
   
    % Cantidad máxima de niveles
    M = max(Niveles);
    % Cuántos de esos niveles moverá
    m = randi(M-1);
    for n = randperm(M-1,m)+1   % Evita seleccionar el nivel 1
        % Recorro los niveles seleccionados
        i = find(Niveles == n);
        ni = numel(i);
        for j = 1:floor(ni/2)
            % Recorre la mitad
            if ni > 1
                % Recorriendo todas las tareas del mismo nivel, las
                % intercambio con las tareas "contrarias".
                % Cambia la primera tarea con la última.
                [fil1,col1] = ind2sub(size(q),find(q == i(end-(j-1))));
                [fil2,col2] = ind2sub(size(q),find(q == i(j)));
                % Selecciono sólo los que cumplen con 'p'
                i1 = sortrows([fil1 col1],1);
                i1 = i1(:,2);
                i2 = sortrows([fil2 col2],1);
                i2 = i2(:,2);
                for t = 1:numel(q(:,1))
                    if p(t) == 1
                        qNew(t,[i1(t) i2(t)]) = q(t,[i2(t) i1(t)]);
                    end
                end
            end
        end
%{        
        i1 = q == i(1);
        i2 = q == i(2);

        if numel(i) > 1
            % Sólo invierte las tareas del mismo nivel
            for pp = 1:numel(p)
                if all(p) ~= 0
                    idx = ismembc(q(pp,:),i);
                    qNew(p,idx) = q(p,i(end:-1:1));
                else
                    qNew(pp,:) = zeros(q(1,:));
                end
            end
        end
%}
    end
end
%}
%% INSERCIÓN
function qNew = Insercion(Q,N)

% Selecciona la tarea a insertar
i = randi([1 max(Q)],1);
idxI = find(Q == i);
[Pred,Sucs] = ObtenerLimites(N,i,Q);
idxPos = BuscarIndice(Pred,Sucs,Q);
% NOTA: Esta operación no genera soluciones inviables.
if idxPos > idxI
    qNew = [Q(1:idxI-1) Q(idxI+1:idxPos-1) Q(idxI) Q(idxPos:end)];
elseif idxPos < idxI
    qNew = [Q(1:idxPos-1) Q(idxI) Q(idxPos:idxI-1) Q(idxI+1:end)];
else
    qNew = Q;
end
end

%% LEVY FLIGHTS
function [stepSize,j] = LevyFlights(Fitness)
    
    global nSol;
    alpha = 1.5;
    s = 5.9;
    j = randi([1 nSol]);
    F = Fitness(j);
    
    u = F - min(Fitness);
    v = max(Fitness) - min(Fitness);
    if v == 0
        stepSize = 0;
    else
        u = u / v;
        stepSize = exp(-s*u.^alpha);
    end
end