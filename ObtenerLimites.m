%% OBTENER LÍMITES
function [Pred,Sucs] = ObtenerLimites(N,i,Q)
% Calcula el índice del predecesor y sucesor
% N: Matriz de precedencias
% i: Tarea en cuestión
% j: Solución en 'q' a la cual debe calcularse
% q: Soluciones del problema RCPCP
%%% PREDECESORES
pred = find(N(i+1,:)) - 1;
if numel(pred) > 1
    % Si hay más de un predecesor, debe elegir el que comience
    % último
    V = find(Q == pred(1));
    Pred = pred(1);
    for a = pred(2:end)
        Vp = find(Q == a);
        if Vp > V
            V = Vp;
            Pred = a;
        end
    end
else
    Pred = pred;
end
%%% SUCESORES
sucs = find(N(:,i+1)) - 1;
if numel(sucs) > 1
    % Si hay más de un sucesor, debe elegir el que comience
    % último
    V = find(Q == sucs(1));
    Sucs = sucs(1);
    for a = sucs(2:end)'
        Vp = find(Q == a);
        if Vp < V
            V = Vp;
            Sucs = a;
        end
    end
else
    Sucs = sucs;
end
end