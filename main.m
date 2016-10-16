clc;
clear;
close all;

global sumDev;
sumDev = 0;

Test = 'j30';
%Test = '[]';
T = UsarModelo(Test);
for it = 1:T

    Modelo = CargarModelo(Test,it,T);

    [Sol,MC,MPE] = CuckooSearch(Modelo,T);

    AnalizarResultados(Modelo, Sol.Cmax, it, T, Test);

    if T == 1
        ImprimirResultados(Modelo, Sol.I, MC, MPE);
    end
end

fclose('all');