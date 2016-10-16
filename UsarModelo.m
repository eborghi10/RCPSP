function loops = UsarModelo(str)

if nargin == 1
    if strcmp(str,'j30')
        loops = 480;
    elseif strcmp(str,'j60')
        loops = 450;
    elseif strcmp(str,'j90')
        loops = 445;
    elseif strcmp(str,'j120')
        loops = 600;
    elseif strcmp(str,'[]')
        loops = 1;
    else
        error('Tarea no existente');
    end
end
end