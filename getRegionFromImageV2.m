function [region] = getRegionFromImageV2(data, a)
    %GETREGIONFROMIMAGE Obtains the regions of a image for a determined color
    %   The color value can be 1 for Red, 2 for Green, 3 for blue

    variance = 10;

    [xL, yL, cL] = size(data);
    for i = 1:xL
        for c = 1:cL
            for j = 1:yL
                min = (a(c) - variance);
                if min < 1
                    min = 1;
                end
                if data(i, j, c) < min || data(i, j, c) > (a(c) + variance)
                    data(i, j, c) = 0;
                end
            end
        end
    end

    bw = rgb2gray(data);
    % Remove the small objects by a min pixel value
    bw_area = bwareaopen(bw, 300);
    % Obtain the logical information, kind of agruping where values are
    % different that 0
    bw_logical = logical(bw_area);
    % Obtain the information, centroid and bounding box for the logical data_x
    region = regionprops(bw_logical, 'BoundingBox', 'Centroid');
    
end

