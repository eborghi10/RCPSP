
function [Cmax,J] = ObtenerMejorSolucion(Modelo,Pob)
    
    [Cmax,J] = min(Pob.Fitness);
    
    if numel(J) > 1
        for j = J
            error('Implementar algoritmo!');
        end
    end
end
