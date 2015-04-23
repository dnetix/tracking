function [region] = getRegionsFromImage(data, color)
%GETREGIONFROMIMAGE Obtains the regions of a image for a determined color
%   The color value can be 1 for Red, 2 for Green, 3 for blue

minpixel = 300;
level = 0.18;

% For the layer of the entered color substract the gray version of the
% image, knowing that 30 - 50 = 0
substracted = imsubtract(data(:,:,color), rgb2gray(data));
% Now filter the matrix to reduce noise
filtered = medfilt2(substracted, [3 3]);
% Set this values to black&white ones
bw = im2bw(filtered, level);
% Remove the small objects by a min pixel value
bw_area = bwareaopen(bw, minpixel);
% Obtain the logical information, kind of agruping where values are
% different that 0
bw_logical = logical(bw_area);
% Obtain the information, centroid and bounding box for the logical data
region = regionprops(bw_logical, 'BoundingBox', 'Centroid');
end

