%% Morillo [2014] - Fig.1 y Fig.2

function [Modelo] = CrearModelo3()
% Solución factible óptima: 14
    % Cantidad de recursos
    Modelo.R = 3;
    
    % Consumo de cada tarea
    Modelo.r(1,:) = [0 2 3 1 2 4 1 3 1 2 0];
    Modelo.r(2,:) = [0 2 1 0 2 0 2 2 1 2 0];
    Modelo.r(3,:) = [0 2 1 1 2 1 2 0 0 3 0];

    % Conjunto de recursos renovables
    Modelo.K = zeros(Modelo.R,1);
    for i = 1:Modelo.R
        Modelo.K(i,:) = 4;
    end
    
    % Cantidad de actividades (tareas no dummies)
    Modelo.n = size(Modelo.r,2)-2;
    
    % Duración de cada actividad
    Modelo.d = [0 3 3 1 1 2 3 2 1 3 0];
    
    % Precedence Constraints
    Modelo.N = zeros(size(Modelo.r,2));
    Modelo.N(2,1) = 1;
    Modelo.N(3,1) = 1;
    Modelo.N(4,1) = 1;
    Modelo.N(5,3) = 1;
    Modelo.N(6,3) = 1;
    Modelo.N(7,1) = 1;
    Modelo.N(8,2) = 1;
    Modelo.N(8,5) = 1;
    Modelo.N(9,3) = 1;
    Modelo.N(10,4) = 1;
    Modelo.N(10,6) = 1;
    Modelo.N(11,7) = 1;
    Modelo.N(11,8) = 1;
    Modelo.N(11,9) = 1;
    Modelo.N(11,10) = 1;
end
