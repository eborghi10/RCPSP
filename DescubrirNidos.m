%% Reemplaza algunos huevos (vacia los nidos), construyendo nuevas soluciones.
%
function [NuevoNido] = DescubrirNidos(Nido,RCPSP)

    global Pa;
    global nSol;
    
    q = Nido.Eggs;
    F = Nido.Fitness;
    N = RCPSP.N;
    % Los huevos intrusos se descubren (y reemplazan por nuevos) con una
    % probabilidad pa.
    % Matriz que indica qué huevos son descubiertos
    K = rand([nSol 1]) > Pa;

    NuevoNido.Eggs = Mutacion(q,K,F,N);
    
    NuevoNido.Fitness = Nido.Fitness;
    for j = 1:nSol
        if K(j)
            NuedoNido.Fitness(j,:) = MakeSpan(RCPSP,NuevoNido.Eggs(j,:));
        end
    end
end

%% MUTACIÓN
function [qNew] = Mutacion(q,K,F,N)
n = numel(q(1,:));
qNew = zeros(size(q));
f = min(F);
for j = 1:numel(q(:,1))
    % Para ser mutada, la tarea debe SER DESCUBIERTA y NO SER LA MEJOR.
    if K(j) && F(j) ~= f
        % Selecciona la cantidad de tareas a swapear
        M = randi(n);
        for m = 1:M
            % Selecciona la tarea a swapear
            Q = q(j,:);
            i = randi([1 max(Q)],1);
            idxI = find(Q == i);
            [Pred,Sucs] = ObtenerLimites(N,i,Q);
            idxPos = BuscarIndice(Pred,Sucs,Q);
% NOTA: Esta operación no genera soluciones inviables.
            if idxPos > idxI
                qNew(j,:) = [q(j,1:idxI-1) q(j,idxPos) ...
                    q(j,idxI+1:idxPos-1) q(j,idxI) q(j,idxPos+1:end)];
            elseif idxPos < idxI
                qNew(j,:) = [q(j,1:idxPos-1) q(j,idxI)...
                    q(j,idxPos+1:idxI-1) q(j,idxPos) q(j,idxI+1:end)];
            else
                qNew(j,:) = q(j,:);
            end
        end
    else
        qNew(j,:) = q(j,:);
    end
end
end
