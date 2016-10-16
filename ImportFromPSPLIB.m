%{
 R. Kolisch, A. Sprecher / European Journal of Operational Research 96
(1996) 205-216.

http://www.om-db.wi.tum.de/psplib/files/Kolisch-Sprecher-96.pdf
http://www.om-db.wi.tum.de/psplib/getdata.cgi?mode=sm
%}

% ImportFromPSPLIB('j301_1.sm');

function [ RCPSP ] = ImportFromPSPLIB( File )
% Función que reemplaza a CrearModelo() para importar Data Sets de PSPLIB.
    fid = fopen(File);
    while 1
        C = fgetl(fid);

        if ~ischar(C)
            % Break if we hit end of file
            break
        end
        
        if ~isempty(strfind(C,' renewable'))
            % Cantidad de recursos
            str = strsplit(C,{'- renewable                 :  ','   R'});
            % str2double es mas rapido que str2num
            RCPSP.R = str2double(str{2}); 
        elseif ~isempty(strfind(C,'supersource'))
            % Cantidad de actividades NO dummies
            str = strsplit(C,{'jobs (incl. supersource/sink ):  '});
            RCPSP.n = str2double(str{2})-2;
        elseif ~isempty(strfind(C,...
                'jobnr.    #modes  #successors   successors'))
            % Crea la matriz de precedencia
            RCPSP.N = zeros(RCPSP.n+2);
            for i=1:RCPSP.n+2
                C = fgetl(fid);
                data = strsplit(C,' ');
                for j=1:str2double(data{4})
                    sucs = str2double(data{4+j});
                    pred = str2double(data{2});
                    RCPSP.N(sucs,pred) = 1;
                end
            end
        elseif ~isempty(strfind(C,'DURATIONS'))
            % Crea las matrices de duracion y consumo de recursos
            RCPSP.r = zeros(RCPSP.R,RCPSP.n+2);
            RCPSP.d = zeros(1,RCPSP.n+2);
            fgetl(fid); fgetl(fid);
            for i = 1:RCPSP.n+2
                C = fgetl(fid);
                data = strsplit(C,' ');
                for j = 1:RCPSP.R
                    if i < 100
                        % Si el primer elemento de la fila es menor que
                        % 100, se genera un espacio en blanco al principio.
                        J = str2double(data{2});
                        RCPSP.r(j,J) = str2double(data{4+j});
                        RCPSP.d(i) = str2double(data{4});
                    else
                        J = str2double(data{1});
                        RCPSP.r(j,J) = str2double(data{3+j});
                        RCPSP.d(i) = str2double(data{3});
                    end
                end
            end
        elseif ~isempty(strfind(C,'RESOURCEAVAILABILITIES'))
            % Obtiene la cantidad maxima de disponibilidad de recursos
            RCPSP.K = zeros(RCPSP.R,1);
            fgetl(fid);
            C = fgetl(fid);
            data = strsplit(C,' ');
            for k = 1:RCPSP.R
                RCPSP.K(k,:) = str2double(data{k+1});
            end
        end
    end
    fclose(fid);
end

