function [ Sol, MC,MPE ] = CuckooSearch( Modelo,T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Parámetros del algoritmo de Optimización
% Cuckoo Search

global nSol;
nSol = 25;      % Cantidad de nidos/huevos(= soluciones)
% Probabilidad de EXPLORACIÓN/EXPLOTACIÓN
global Pa;
Pa = 0.25;       % Tasa de descubrir huevos "infiltrados"
                  % Probabilidad de Abandono de un nido
                  
MaxIt = 400;      % Cantidad de iteraciones máximas

mpe = @(F,C) 100 * sum((F - C)./ F) / nSol;
meanRUR = @(RCPSP,Res,C) mean(RUR(RCPSP,Res,C));

%{
%  1) GENERA UNA POBLACIÓN INICIAL ALEATORIA.
%}

Pob = CrearSolucionesAleatorias(Modelo,'ActivityList');
% x = CrearSolucionesAleatorias(Modelo,'RandomKey');

MejoresCostos = zeros(MaxIt,1);
MPE = zeros(MaxIt,1);
it = 0;


%% Loop principal

while (it < MaxIt) 
    
    it = it + 1;
    
    %{
    %  2) GENERAR UNA NUEVA SOLUCIÓN.
    %}
    NewEgg = GenerarNuevaSolucion(Pob,Modelo);
    
    %{
    %  3) EVALÚA SU CALIDAD.
    %}
    [Cmax, Rk] = MakeSpan(Modelo,NewEgg);
    
    j = randi(nSol);
    Fj = Pob.Fitness(j,:);
    if Cmax < Fj
        % Evito el cálculo innecesario de RUR().
        Pob.Fitness(j,:) = Cmax;
        Pob.Eggs(j,:) = NewEgg;
    elseif Cmax == Fj
        [~, Rj] = MakeSpan(Modelo,Pob.Eggs(j,:));
        if meanRUR(Modelo,Rk,Cmax) < meanRUR(Modelo,Rj,Fj)
            % En "Best" se guarda la mejor solución entre todas las
            % iteraciones.
            Pob.Fitness(j,:) = Cmax;
            Pob.Eggs(j,:) = NewEgg;
        end
    end
    
    %{
    %  5) DIVERSIFICACIÓN.
    %}
    Pob = DescubrirNidos(Pob,Modelo);
    
    %{
    %  6) OBTIENE LA MEJOR SOLUCIÓN
    %}
    [Cmax,j] = ObtenerMejorSolucion(Modelo,Pob);
    MPE(it) = mpe(Pob.Fitness,Cmax);
    MejoresCostos(it) = Cmax;
    
    Sol.I = Pob.Eggs(j,:);
    Sol.Cmax = Cmax;
    
    if T == 1
        % Por cada iteración, muestra información en pantalla
        disp([num2str(it) ' :: Mejor Costo = ' num2str(MejoresCostos(it))]);
    end

    if MPE(it) == 0 
        % Termina en caso de que no haya cambiado la calidad de las
        % soluciones
        break;
    end
    
end
MC = MejoresCostos(1:it);
MPE = MPE(1:it);
end

