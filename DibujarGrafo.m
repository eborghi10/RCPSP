function [Niveles] = DibujarGrafo( G )
%DIBUJAR_GRAFO Dibuja en pantalla el grafo del RCPSP.
   
    % D: Vector de Nodos a explorar/graficar
    D = zeros(3,G.n+2); % 2 filas
    % Fila #1: Bool -> Si ya fue incluida en [x,y]
    % Fila #2: Cantidad de sucesores
    % Fila #3: Nivel dentro de la red
    Niveles = zeros(1,G.n+2);
    y = zeros(1,G.n+2);
    D(1,1) = 1;
    Nivel = 1 ;
    u = [];
    while 1
        % Agrega sucesores de 'u' que no estén en 'D'.
        for U = u
            D(1,:) = D(1,:) | G.N(:,U)';
            D(2,U) = numel(find(G.N(:,U)));
        end
        % ASIGNO NIVEL
        % J: Tareas que fueron colocadas pero no tienen un nivel asignado
        u = find(D(1,:) & ~D(3,:));
        if ~isempty(u)
            % Si los nuevos sucesores no fueron colocados, les asigno el
            % nivel siguiente.
            % Si todos los predecesores de 'J' tienen nivel asignado.
            u = u(all((repmat(D(3,:),length(u),1) & G.N(u,:)) == ...
                G.N(u,:),2));
            D(3,u) = Nivel;
            Nivel = Nivel + 1;
        else
            % Salida
            break;
        end
        % VERIFICO SI LA CANTIDAD DE NODOS DE Nivel-1 ES PAR O IMPAR
        % u: nodos de Nivel-1
        % v: Cantidad de nodos de Nivel-1
        v = numel(u);
        if ~mod(v,2)
            % Si es par...
            n_max = v/2;
            for n_j = 1:n_max
                y(u(n_max -n_j +1)) = n_j - 1/2;  % Mitad superior
                y(u(n_max +n_j)) = 1/2 - n_j;     % Mitad inferior
            end
        else
            % Impar...
            c = round(v/2);
            y(u(c)) = 0;
            n_max = v-1;
            for n_j = 1:(n_max/2)
                y(u(c -n_j)) = n_j;
                y(u(c +n_j)) = -n_j;
            end
        end
        Niveles(u) = Nivel - 1;
    end
    %% Figura
    figure();
    axis off;
    hold on;
    %% Edge
    for i = numel(Niveles):-1:2
        P = find(G.N(i,:));
        for p = P
             line([Niveles(p) Niveles(i)],[y(p) y(i)],...
                 'Color', [0.62 0.34 0.5],...
                 'LineWidth',2);
        end
    end
    %% Nodes
    scatter(Niveles, y, 3000, [0.92 0.6 0.77], 'filled',...
        'MarkerEdgeColor', [0.62 0.34 0.5]);
    %% Leyendas (texto - recursos - duraciones)
    text(Niveles - 0.035, y + 0.015,...
        strtrim(cellstr(num2str((1:G.n+2)'))'),...
        'Color',[0.9 0.9 0.9],...
        'FontSize',12,'FontWeight','bold');
    hold off;
end

