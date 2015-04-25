%% Prueba de concepto usada
%% Obtencion de la informacion de la imagen

% Cargamos en una variable la informacion RGB de la imagen de prueba
data = imread('resources\rubik.jpg');
% Mostramos la imagen antes de realizar cualquier procedimiento
imshow(data);

%% Seleccion del pixel con el color deseado

% Selecciono el color verde de la imagen
pixelRGB = impixel(data);
% Se muestra el valor de los componentes RGB del pixel seleccionado
pixelRGB

%% Filtrado de color

% Establezco una varianza de 10
variance = 10;
[xL, yL, ~] = size(data);
% Compruebo que sea una matriz de nxmx3
% Creo una matriz de igual tamaño llena de 0
bw = zeros(xL,yL);
% Separo la informacion de la imagen en las 3 capas de color
r = data(:,:,1);
g = data(:,:,2);
b = data(:,:,3);
%% Eliminacion de valores

% Para este proceso se obtienen las posiciones de la matriz que cumplan
% con todas las condiciones.

% Como primera eliminacion calculo el valor minimo en rojo
min = pixelRGB(1) - variance;
if min < 0
    min = 0;
end
% Obtengo todas las posiciones que sean mayores o iguales al valor
% minimo
positions = find(r >= min);
% Una vez tengo los que estan en el rango minimo ahora los intersecto
% con que esten por el rango superior
positions = intersect(positions, find(r <= (pixelRGB(1) + variance)));

% Mismo proceso con la capa verde, obtengo el valor minimo en verde
min = pixelRGB(2) - variance;
if min < 0
    min = 0;
end
% Intersecto las posiciones que ya se obtuvieron de rojo con las que
% sean mayores al valor minimo en verde
positions = intersect(positions, find(g >= min));
% Luego intersecto con las posiciones que cumplan la condicion para el
% maximo
positions = intersect(positions, find(g <= (pixelRGB(2) + variance)));

% Mismo proceso con la capa azul, obtengo el valor minimo en azul
min = pixelRGB(3) - variance;
if min < 0
    min = 0;
end
% Intersecto las posiciones que ya se obtuvieron de rojo y verde con las que
% sean mayores al valor minimo en azul
positions = intersect(positions, find(b >= min));
% Luego intersecto con las posiciones que cumplan la condicion para el
% maximo
positions = intersect(positions, find(b <= (pixelRGB(3) + variance)));

% Luego de este proceso se obtiene un vector de posiciones que hayan
% cumplido todas las condiciones, para estos valores le asigno el valor
% de 1 en la matriz binaria creada anteriormente
for i = 1:length(positions)
    bw(positions(i)) = 1;
end

imshow(bw);

%% Obtencion de los centros y las cajas de union

imshow(data);
% Remuevo los 1 que se encuentren muy aislados para remover ruido
bw = bwareaopen(bw, 300);
% Se obtienen los valores de Centro y caja de union determinados regiones
regions = regionprops(bw, 'BoundingBox', 'Centroid');
% Dibujamos las cajas y los centros en la imagen
hold on
for object = 1:length(regions)
    bb = regions(object).BoundingBox;
    bc = regions(object).Centroid;
    rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 1)
    plot(bc(1), bc(2), '-m+')
    a=text(bc(1) + 15, bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
    set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
end
hold off

%% Resultados

% Tiempo de procesado de imagenes de diferentes tamaños
a = [2000, 1600, 1200, 800, 400, 200, 100];
times = zeros(1, length(a));
addpath function;
for i = 1:length(a)
    data = imread(['resources\rubik_', int2str(a(i)), '.jpg']);
    start = tic;
    hold on;
    regions = getRegionsColor(data, a, 10);
    hold off;
    times(i) = toc(start);
end
plot(a, times);
ylabel('Segundos'); xlabel('Pixeles cuadrados');
rmpath function;
