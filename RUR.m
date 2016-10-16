function [ratio] = RUR(RCPSP,Rk,Cmax)
% Resource-Utilisation Ratio: Valls [2008]
    R = RCPSP.R;
    K = RCPSP.K;
    ratio = zeros(1,Cmax);
    
    for i = 1:R
        r = Rk(i,:) ./ K(i,:);
        ratio = ratio + (ones(1,Cmax) - r(1:Cmax))/R;
    end
end
