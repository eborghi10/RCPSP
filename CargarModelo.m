function [ Modelo ] = CargarModelo( str, it, T )
%% Definición del problema
if ~strcmp(str,'[]')
    param = ceil(it/10);
    inst = mod(it,10);
    if inst == 0
        inst = 10;
    end
    if strcmp(str,'j30')    
        File = strcat('Tests/j30/j30',num2str(param),'_',num2str(inst),'.sm');
    elseif strcmp(str,'j60')
        File = strcat('Tests/j60/j60',num2str(param),'_',num2str(inst),'.sm');
    elseif strcmp(str,'j90')
        File = strcat('Tests/j90/j90',num2str(param),'_',num2str(inst),'.sm');
    elseif strcmp(str,'j120')
        File = strcat('Tests/j120/j120',num2str(param),'_',num2str(inst),'.sm');
    else
        error('Error al cargar modelo');
    end
    Modelo = ImportFromPSPLIB(File);
    if strcmp(str,'j30')
        File = strcat('DataSets/j30opt.sm');
        Modelo.opt = CargarOptimo(File,it);
        Modelo.instances = inst;
    elseif strcmp(str,'j60')
        File = strcat('DataSets/j60lb.sm');
        Modelo.opt = CargarLimite(File,it);
        Modelo.instances = inst;
    elseif strcmp(str,'j90')
        File = strcat('DataSets/j90lb.sm');
        Modelo.opt = CargarLimite(File,it);
        Modelo.instances = inst;
    elseif strcmp(str,'j120')
        File = strcat('DataSets/j120lb.sm');
        Modelo.opt = CargarLimite(File,it);
        Modelo.instances = inst;
    else
        error('Error cargando modelo.');
    end
else
    Modelo = CargarOtros();
end

if T == 1
    %DibujarGrafo(Modelo);
    Modelo.Niveles = DibujarGrafo(Modelo);
end
end

%%
function [opt] = CargarOptimo(File,it)
fid = fopen(File);
while 1
    C = fgetl(fid);

    if ~isempty(strfind(C,'Par'))
        C = fgetl(fid);
        for ii = 1:it
             C = fgetl(fid);
        end
        str = strsplit(C);
        opt = str2double(str(3));
        break;
    end
end
end

%%
function [opt] = CargarLimite(File,it)
fid = fopen(File);
while 1
    C = fgetl(fid);

    if ~isempty(strfind(C,'Par'))
        C = fgetl(fid);
        for ii = 1:it
             C = fgetl(fid);
        end
        str = strsplit(C);
        opt = str2double(str(4));   % LB
        break;
    end
end
end

function [Modelo] = CargarOtros()
%Modelo = CrearModelo1();                          % MEJOR: 14
%Modelo.opt = [];
%Modelo.instances = [];
%Modelo = CrearModelo2();                          % MEJOR: 44
%Modelo.opt = [];
%Modelo.instances = [];
%Modelo = CrearModelo3();                          % MEJOR: 13
%Modelo.opt = [];
%Modelo.instances = [];
%Modelo = CrearModelo4();                          % MEJOR: 20
%Modelo.opt = [];
%Modelo.instances = [];

%%% PSPLIB DATASETS:
%Modelo = ImportFromPSPLIB('Tests/j30/j301_1.sm'); % MEJOR: 43 (43)
%Modelo.opt = 43;
%Modelo.instances = 1;
%Modelo = ImportFromPSPLIB('Tests/j30/j301_6.sm'); % MEJOR: 49 (48)
%Modelo.opt = 48;
%Modelo.instances = 6;
%Modelo = ImportFromPSPLIB('Tests/j30/j301_8.sm'); % MEJOR: 53 (53)
%Modelo.opt = 53;
%Modelo.instances = 8;
%Modelo = ImportFromPSPLIB('Tests/j30/j303_5.sm'); % MEJOR: 53 (53)
%Modelo.opt = 53;
%Modelo.instances = 5;
%Modelo = ImportFromPSPLIB('Tests/j30/j305_1.sm'); % MEJOR: 54 (53)
%Modelo.opt = 53;
%Modelo.instances = 1;
%Modelo = ImportFromPSPLIB('Tests/j30/j306_5.sm'); % MEJOR: 68 (67)
%Modelo.opt = 67;
%Modelo.instances = 5;
%Modelo = ImportFromPSPLIB('Tests/j30/j307_4.sm'); % MEJOR: 44 (44)
%Modelo.opt = 44;
%Modelo.instances = 4;
%Modelo = ImportFromPSPLIB('Tests/j30/j308_4.sm'); % MEJOR: 48 (48)
%Modelo.opt = 48;
%Modelo.instances = 4;
%Modelo = ImportFromPSPLIB('Tests/j30/j3010_5.sm');% MEJOR: 44 (41)
%Modelo.opt = 41;
%Modelo.instances = 5;
%Modelo = ImportFromPSPLIB('Tests/j30/j3012_6.sm');% MEJOR: 53 (53)
%Modelo.opt = 53;
%Modelo.instances = 6;
%Modelo = ImportFromPSPLIB('Tests/j30/j3020_7.sm');% MEJOR: 42 (42)
%Modelo.opt = 42;
%Modelo.instances = 7;
%Modelo = ImportFromPSPLIB('Tests/j30/j3026_4.sm');% MEJOR: 62 (62)
%Modelo.opt =62;
%Modelo.instances = 4;
%Modelo = ImportFromPSPLIB('Tests/j30/j3039_1.sm');% MEJOR: 55 (55)
%Modelo.opt = 55;
%Modelo.instances = 1;
%Modelo = ImportFromPSPLIB('Tests/j30/j3046_4.sm');% MEJOR: 70 (64)
%Modelo.opt = 64;
%Modelo.instances = 4;
%% Soluciones que no se conoce la solución exacta:
% Lower Bound: se obtiene con el Critical-Path Method
% Upper Bound: Mejor solución actual
%Modelo = ImportFromPSPLIB('Tests/j60/j601_2.sm');    % MEJOR: 71 (68)
%Modelo.opt = 68;
%Modelo.instances = 2;
%Modelo = ImportFromPSPLIB('Tests/j60/j601_4.sm');    % MEJOR: 93 (91)
%Modelo.opt = 91;
%Modelo.instances = 4;
%Modelo = ImportFromPSPLIB('Tests/j60/j601_8.sm');    % MEJOR: 78 (75)
%Modelo.opt = 75;
%Modelo.instances = 8;
%Modelo = ImportFromPSPLIB('Tests/j60/j601_9.sm');    % MEJOR: 85 (85)
%Modelo.opt = 85;
%Modelo.instances = 9;
%Modelo = ImportFromPSPLIB('Tests/j60/j602_5.sm');    % MEJOR: 54 (54)
%Modelo.opt = 54;
%Modelo.instances = 5;
%Modelo = ImportFromPSPLIB('Tests/j60/j6019_6.sm');    % MEJOR: 69 (69)
%Modelo.opt = 69;
%Modelo.instances = 6;
%%
%Modelo = ImportFromPSPLIB('Tests/j90/j901_1.sm');    % MEJOR: 81 (73)
%Modelo.opt = 73;
%Modelo.instances = 1;
%Modelo = ImportFromPSPLIB('Tests/j90/j901_2.sm');    % MEJOR: 92 (92)
%Modelo.opt = 92;
%Modelo.instances = 2;
%Modelo = ImportFromPSPLIB('Tests/j90/j901_4.sm');    % MEJOR: 87 (86)
%Modelo.opt = 86;
%Modelo.instances = 4;
%Modelo = ImportFromPSPLIB('Tests/j90/j901_9.sm');    % MEJOR: 80 (72)
%Modelo.opt = 72;
%Modelo.instances = 9;
%Modelo = ImportFromPSPLIB('Tests/j90/j902_2.sm');    % MEJOR: 114 (114)
%Modelo.opt = 114;
%Modelo.instances = 2;
%Modelo = ImportFromPSPLIB('Tests/j90/j902_8.sm');    % MEJOR: 82 (82)
%Modelo.opt = 82;
%Modelo.instances = 8;
%Modelo = ImportFromPSPLIB('Tests/j90/j9043_7.sm');    % MEJOR: 89 (88)
%Modelo.opt = 88;
%Modelo.instances = 7;
%%
%Modelo = ImportFromPSPLIB('Tests/j120/j1201_1.sm');   % MEJOR: 118 (104)
%Modelo.opt = 104;
%Modelo.instances = 1;
%Modelo = ImportFromPSPLIB('Tests/j120/j1201_3.sm');   % MEJOR: 131 (125)
%Modelo.opt = 125;
%Modelo.instances = 3;
%Modelo = ImportFromPSPLIB('Tests/j120/j1201_5.sm');   % MEJOR: 126 (112)
%Modelo.opt = 112;
%Modelo.instances = 5;
%Modelo = ImportFromPSPLIB('Tests/j120/j1201_10.sm');   % MEJOR: 132 (108)
%Modelo.opt = 108;
%Modelo.instances = 10;
%Modelo = ImportFromPSPLIB('Tests/j120/j1202_1.sm');   % MEJOR: 95 (87)
%Modelo.opt = 87;
%Modelo.instances = 1;
%Modelo = ImportFromPSPLIB('Tests/j120/j1202_5.sm');   % MEJOR: 119 (103)
%Modelo.opt = 103;
%Modelo.instances = 5;
%Modelo = ImportFromPSPLIB('Tests/j120/j1202_7.sm');   % MEJOR: 101 (90)
%Modelo.opt = 90;
%Modelo.instances = 7;
Modelo = ImportFromPSPLIB('Tests/j120/j1205_8.sm');   % MEJOR: 79 (78)
Modelo.opt = 78;
Modelo.instances = 8;
end