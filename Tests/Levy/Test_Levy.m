Levy = @(s,u) exp(-s*u.^1.5);

ezsurfc(Levy,[1 20 0 1]);