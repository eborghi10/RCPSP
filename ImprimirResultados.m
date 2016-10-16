function ImprimirResultados( Modelo, BestSol, MejoresCostos, MPE )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Imprime los resultados finales
% SOLUCIÓN
SerialSGS(Modelo,BestSol,1);
figure();
subplot(2,1,1);
plot(MejoresCostos,'LineWidth',2);
title('Evolución del costo');
xlabel('Iteracion');
ylabel('Mejor Costo');
grid on;
% CALIDAD DE LAS SOLUCIONES
subplot(2,1,2);
plot(MPE,'LineWidth',2);
xlabel('Tiempo');
ylabel('MPE [%]');
title('Mean Percentage Error');
end

