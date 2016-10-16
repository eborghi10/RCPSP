function Modelo = CrearModelo4()
% "A Genetic-Local Search Algorithm Approach for Resource Constrained
% Project Scheduling Problem" - Kadam [2015]
    % Possible feasible solutions: 
    % - L1 = {2 1 5 4 6 3 7 10 9 8}
    % - L2 = {1 3 2 5 6 4 10 7 9 8}
    % - L3 = {1 2 5 3 4 6 7 10 8 9} -> Cmax=21
    Modelo.R = 1;
    Modelo.r(Modelo.R,:) = [0 3 2 4 3  3 1 1 2 1 3 0];
    Modelo.K = zeros(Modelo.R,1);
    for i = 1:Modelo.R
        Modelo.K(i,:) = 4;
    end
    Modelo.n = size(Modelo.r,2)-2;
    Modelo.d = [0 4 3 5 1 2 5 2 3 4 2 0];
    Modelo.N = zeros(size(Modelo.r,2));
    Modelo.N(2,1) = 1;
    Modelo.N(3,1) = 1;
    Modelo.N(4,2) = 1;
    Modelo.N(5,3) = 1;
    Modelo.N(6,2) = 1;
    Modelo.N(7,3) = 1;
    Modelo.N(8,5) = 1;
    Modelo.N(8,7) = 1;
    Modelo.N(9,4) = 1;
    Modelo.N(9,8) = 1;
    Modelo.N(10,6) = 1;
    Modelo.N(11,7) = 1;
    Modelo.N(12,9) = 1;
    Modelo.N(12,10) = 1;
    Modelo.N(12,11) = 1;
end
