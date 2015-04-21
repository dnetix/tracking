data = imread('rubik.png');

figure('Name', 'Rojo'); imshow(data);
displayMatchedBoxes(getRegionFromImage(data, 2));