function Pob = CrearSolucionesAleatorias(Modelo,str)
    global nSol;
    % "Activity Lists" por defecto
    if nargin < 2
        str = 'ActivityList';
    end
    
    if strcmp(str,'ActivityList')
        Pob.Eggs = zeros(nSol,Modelo.n);
        for i = 1:nSol
            Pob.Eggs(i,:) = randperm(Modelo.n);
        end
    elseif strcmp(str,'RandomKey')
        Pob.Eggs = rand(nSol,Modelo.n);
    else
        error('Error generando soluciones iniciales aleatorias');
    end
    Pob.Fitness = zeros(nSol,1);
    
    for i = 1:nSol
        % Convierte las tareas en viables
        x = SerialSGS(Modelo,Pob.Eggs(i,:),0);
        Pob.Eggs(i,:) = x.Sol;
        Pob.Fitness(i) = x.Cmax;
    end
end

