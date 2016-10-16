%% 
% Función que "adapta" la solución generada por otras funciones a:
%  - Obtener una solución limita entre [Lb:Ub], donde Lb y Ub son
%    números naturales.
%
% Del libro:
% "Resource-Constrained Project Scheduling: Models, Algorithms, Extensions
% and Applications". Chapter 1: The Resource-Constrained Project
% Scheduling (página 23). Christian ARTIGUES.
%
% ISBN: 978-1-84821-034-9
%
% "Consider a non-integer schedule S and let Ai the first activity in the
% increasing start time order. Then setting Si to its nearest lower integer
% does not violate any precedence constraints, since the completion time of
% predecessors of Ai are integers strictly lower than Si.
%

% TODO: TRATAR DE QUITAR EL LAZO FOR!!!

function A = srk2al(s)
% Standarized Random Key (SRK) to Activity List (AL) representation
% TEST:
% s = [0.3989 0.8145 0.1769 0.2486 0.9397 0.9713 0.1771];
% I = [3 7 4 1 2 5 6];
% A = [4 5 1 3 6 7 2];
    
    [F, Ub] = size(s);
    % Ordena el vector de tareas 's' y devuelve los índices correspondientes.
    [~,I] = sort(s,2);
    % Asignación rápida:
    % En la posición donde está la menor tarea, se asigna la tarea '1'.
    % En la posición donde está la tarea más grande, se asigna el '7'.
    % 0.003895 seugndos
    A = zeros([F Ub]);
    for i = 1:F
        A(i,I(i,1:Ub)) = (1:Ub);  % repmat([1:Ub],F,1);
    end 
    % 0.004182 segundos
    %A(:,I(:,1:Ub)) = repmat(1:Ub,F,1);
end
