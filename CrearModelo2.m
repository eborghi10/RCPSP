%{
% "A Decomposition-Based Genetic Algorithm for the Resource-Constrained
% Project-Scheduling Problem" - Debels, Vanhoucke (2007).
%}

function Modelo = CrearModelo2()
    Modelo.R = 1;
    Modelo.r(Modelo.R,:) = [0 2 2 6 5 5 3 4 7 3 2 4 4 4 4 1 1 3 2 3 0];
    Modelo.K = zeros(1,Modelo.R);
    for i = 1:Modelo.R
        Modelo.K(:,i) = 10;
    end
    Modelo.n = size(Modelo.r,2)-2;
    Modelo.d = [0 2 5 8 1 10 9 2 3 8 6 6 9 2 8 6 10 5 8 3 0];
    Modelo.N = zeros(size(Modelo.r,2));
    Modelo.N(2,1) = 1;
    Modelo.N(3,1) = 1;
    Modelo.N(4,1) = 1;
    Modelo.N(5,2) = 1;
    Modelo.N(6,3) = 1;
    Modelo.N(7,3) = 1;
    Modelo.N(7,4) = 1;
    Modelo.N(8,1) = 1;
    Modelo.N(9,5) = 1;
    Modelo.N(9,6) = 1;
    Modelo.N(10,6) = 1;
    Modelo.N(11,9) = 1;
    Modelo.N(12,11) = 1;
    Modelo.N(13,9) = 1;
    Modelo.N(13,10) = 1;
    Modelo.N(14,8) = 1;
    Modelo.N(15,7) = 1;
    Modelo.N(15,14) = 1;
    Modelo.N(16,15) = 1;
    Modelo.N(17,14) = 1;
    Modelo.N(18,17) = 1;
    Modelo.N(19,13) = 1;
    Modelo.N(19,16) = 1;
    Modelo.N(20,18) = 1;
    Modelo.N(21,12) = 1;
    Modelo.N(21,19) = 1;
    Modelo.N(21,20) = 1;
end
