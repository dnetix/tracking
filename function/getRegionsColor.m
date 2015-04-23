%% getRegionsColor
% Obtiene las regiones de una informacion de imagen (data) mediante un
% color RGB (a) con una varinza o tolerancia de color (0 - 255)
function [region] = getRegionsColor(data, a, variance)
    % Obtengo las dimensiones de la matriz de informacion
    [xL, yL, cL] = size(data);
    % Compruebo que sea una matriz de nxmx3
    if cL ~= 3
        error('Debe ser una imagen RGB con las 3 capas')
    end
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
    min = a(1) - variance;
    if min < 0
        min = 0;
    end
    % Obtengo todas las posiciones que sean mayores o iguales al valor
    % minimo
    positions = find(r >= min);
    % Una vez tengo los que estan en el rango minimo ahora los intersecto
    % con que esten por el rango superior
    positions = intersect(positions, find(r <= (a(1) + variance)));
    
    % Mismo proceso con la capa verde, obtengo el valor minimo en verde
    min = a(2) - variance;
    if min < 0
        min = 0;
    end
    % Intersecto las posiciones que ya se obtuvieron de rojo con las que
    % sean mayores al valor minimo en verde
    positions = intersect(positions, find(g >= min));
    % Luego intersecto con las posiciones que cumplan la condicion para el
    % maximo
    positions = intersect(positions, find(g <= (a(2) + variance)));

    % Mismo proceso con la capa azul, obtengo el valor minimo en azul
    min = a(3) - variance;
    if min < 0
        min = 0;
    end
    % Intersecto las posiciones que ya se obtuvieron de rojo y verde con las que
    % sean mayores al valor minimo en azul
    positions = intersect(positions, find(b >= min));
    % Luego intersecto con las posiciones que cumplan la condicion para el
    % maximo
    positions = intersect(positions, find(b <= (a(3) + variance)));

    %% Resultado Binario
    % Luego de este proceso se obtiene un vector de posiciones que hayan
    % cumplido todas las condiciones, para estos valores le asigno el valor
    % de 1 en la matriz binaria creada anteriormente
    for i = 1:length(positions)
        bw(positions(i)) = 1;
    end
    % Remuevo los 1 que se encuentren muy aislados para remover ruido
    bw_area = bwareaopen(bw, 300);
    % Obtengo los centros y la cajas de encierro sobre la informacion
    % logica de la matriz.
    region = regionprops(bw_area, 'BoundingBox', 'Centroid');
end

