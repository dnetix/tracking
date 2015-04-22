a = imaqhwinfo;
[camera_name, camera_id, format] = getCameraInfo(a);

color2track = 1;
showBoxes = true;

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

% Set a loop that stop after 100 frames of aquisition
while(vid.FramesAcquired<=200)
    
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
    
    if showBoxes
        displayMatchedBoxes(regions);
    end
    
    if A.count > 0
        circles(A.cxr, A.cyr, A.crr);
    end
    
    A = A.next;
    
    hold off
end
% Both the loops end here.

% Stop the video aquisition.
stop(vid);

% Flush all the image data stored in the memory buffer.
flushdata(vid);

% Clear all variables
sprintf('%s','That was all about Image tracking, Guess that was pretty easy :) ')
