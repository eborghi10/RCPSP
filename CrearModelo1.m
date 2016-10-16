function Modelo = CrearModelo1()
% Valls [2008]
    Modelo.R = 1;
    Modelo.r(Modelo.R,:) = [0 2 6 4 4 3 1 5 0];
    Modelo.K = zeros(Modelo.R,1);
    for i = 1:Modelo.R
        Modelo.K(i,:) = 6;
    end
    Modelo.n = size(Modelo.r,2)-2;
    Modelo.d = [0 4 2 1 4 4 5 3 0];
    Modelo.N = zeros(size(Modelo.r,2));
    Modelo.N(2,1) = 1;
    Modelo.N(3,1) = 1;
    Modelo.N(4,3) = 1;
    Modelo.N(5,4) = 1;
    Modelo.N(6,4) = 1;
    Modelo.N(7,1) = 1;
    Modelo.N(8,2) = 1;
    Modelo.N(9,5) = 1;
    Modelo.N(9,6) = 1;
    Modelo.N(9,7) = 1;
    Modelo.N(9,8) = 1;
end
