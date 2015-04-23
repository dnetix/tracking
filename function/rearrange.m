function [x,y,r, rx, ry] = rearrange(vector)
%REARRANGE Convierte un vector de tipo [x,y,r] y lo descompone en variables
%ademas de generar un rango de x (rx) y y (ry)
% Donde el rango de x y y son estas posiciones +- el radio
    x = vector(1);
    y = vector(2);
    r = vector(3);
    rx = x-r:x+r;
    ry = y-r:y+r;
end

