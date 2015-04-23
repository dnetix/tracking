a = imaqhwinfo;
[camera_name, camera_id, format] = getCameraInfo(a);

color2track = 1;
showBoxes = true;
maxFrames = 50;

% Capture the video frames using the videoinput function
% You have to replace the resolution & your installed adaptor name.
vid = videoinput(camera_name, camera_id, format);

% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 5;

%start the video aquisition here
start(vid)

A = CirclesClass(vid.VideoResolution, 6);

score = 0;

txt = uicontrol('Style', 'text',...
       'String', strcat('Puntaje: 0 - ', int2str(maxFrames)),...
       'Units','pixels',...
       'HorizontalAlignment','left',...
       'ForegroundColor', [0, 0, 1],...
       'FontSize', 24,...
       'Position', [20 10 250 40]);

while(vid.FramesAcquired <= maxFrames)
    
    % Get the snapshot of the current frame
    data = getsnapshot(vid);
    % Turns the video to make it more friendly
    data = flip(data, 2);
    % Now to track red objects in real time
    % we have to subtract the color component
    % from the grayscale image to extract the red components in the image.
    
    regions = getRegionFromImage(data, color2track);
    
    % Display the image
    imshow(data)
    
    hold on
    
    A = A.checkColision(regions);
    score = score + A.collisions;
    
    if showBoxes
        displayMatchedBoxes(regions);
    end
    
    if A.count > 0
        circles(A.cxr, A.cyr, A.crr, 'facealpha', 0.8);
    end
    
    A = A.next;
    
    hold off
    puntaje = strcat('Puntaje: ', int2str(score), ' - ', int2str(maxFrames - vid.FramesAcquired));
    txt.String = puntaje;
end

% Stop the video aquisition.
stop(vid);

% Flush all the image data stored in the memory buffer.
flushdata(vid);

% Clear all variables
sprintf('%s%d','Numero de globos explotados ', score)
