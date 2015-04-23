clc; clear all;
data = imread('small.jpg');

variance = 2;

a = impixel(data);

[xL, yL, cL] = size(data);
bw = zeros(xL,yL);

r = data(:,:,1);
g = data(:,:,2);
b = data(:,:,3);

% Primera eliminacion de resultados, los que no esten en el rango de Rojo
% por debajo
min = a(1) - variance;
if min < 0
    min = 0;
end
positions = find(r >= min);
% Una vez tengo los que estan en el rango minimo ahora los recorto por los
% que no esten por el rango superior

positions = intersect(positions, find(r <= (a(1) + variance)));
% Ahora con el verde

min = a(2) - variance;
if min < 0
    min = 0;
end
positions = intersect(positions, find(g >= min));
positions = intersect(positions, find(g <= (a(2) + variance)));

min = a(3) - variance;
if min < 0
    min = 0;
end
positions = intersect(positions, find(b >= min));
positions = intersect(positions, find(b <= (a(3) + variance)));

for i = 1:length(positions)
    bw(positions(i)) = 1;
end

imshow(bw); impixelinfo
