A = CirclesClass;
A = A.add([140,445,40]);
A = A.add([54,202,30]);
A = A.add([223,202,30]);

data = imread('rubik.png');

% Displays the bounding boxes for the blue color
figure('Name', 'Azul'); imshow(data);
region = getRegionFromImage(data, 2);
displayMatchedBoxes(region);

% Paint a circle on the image
circles(A.cxr, A.cyr, A.crr, 'facecolor', 'red');
