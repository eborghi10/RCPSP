%{
% RESOURCE UTILISATION
% Valls [2008]: Pág. 498 - Sección 2.2: "The Peak Crossover Operator"
%}

%{
% NOMENCLATURA:
%
% R:  Cant. de recursos renovables
% Rk: Disponibilidad del recurso 'k' en cada unidad de tiempo
% K:  Cant. máxima de stock de cada recurso
%}

function ruGraph(RUR,Cmax)
% Plots the Resource-Utilisation Graph
    figure();
    bar(RUR, 0.7,'EdgeColor',[0 .9 .9],'LineWidth',1.5);
    title('Resource-Utilisation Graph');
    xlabel('Tiempo');
    ylabel('Recursos');
    ylim([0 1]);
    xlim([0 Cmax+1]);   % [0 Cmax]: Se ve mal
    hold on;
    plot(linspace(0,Cmax),0.8,'r.','LineWidth',2);
end
