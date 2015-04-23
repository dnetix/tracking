addpath function

% Cargo una imagen de prueba
data = imread('resources\rubik.png');
% Obtengo los datos RGB de un pixel seleccionado
a = impixel(data);
% Muestra la imagen en pantalla
imshow(data);
% Obtengo las regiones que contienen el color seleccionado
regions = getRegionsColor(data, a, 10);
% Muestra las regiones obtenidas
displayRegions(regions);

rmpath function