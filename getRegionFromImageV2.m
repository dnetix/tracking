function [region] = getRegionFromImageV2(data, a, variance)
    %GETREGIONFROMIMAGE Obtains the regions of a image for a determined color
    %   The color value can be 1 for Red, 2 for Green, 3 for blue

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
    

    % bw = rgb2gray(data);
    % Remove the small objects by a min pixel value
    bw_area = bwareaopen(bw, 300);
    % Obtain the logical information, kind of agruping where values are
    % different that 0
    bw_logical = logical(bw_area);
    % Obtain the information, centroid and bounding box for the logical data_x
    region = regionprops(bw_logical, 'BoundingBox', 'Centroid');
end

