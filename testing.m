data = imread('rubik.png');

A = CirclesClass(size(data), 6);
A = A.add([140,445,40]);
A = A.add([409,434,50]);
A = A.add([223,202,30]);

% Bounding Boxes for identified colors
regions = getRegionFromImage(data, 2);

% % Displays the bounding boxes for the blue color
% figure(1); imshow(data);
% displayMatchedBoxes(regions);
% % Paint a circle on the image
% circles(A.cxr, A.cyr, A.crr, 'facecolor', 'red');
% impixelinfo;

A = A.checkColision(regions);
figure(1); imshow(data);
displayMatchedBoxes(regions);
txt = uicontrol('Style', 'text',...
       'String', 'Puntaje ',...
       'Units','normalized',...
       'HorizontalAlignment','left',...
       'Position', [0 0.9 0.5 0.05])
% Paint a circle on the image
circles(A.cxr, A.cyr, A.crr, 'facecolor', 'red');
impixelinfo;