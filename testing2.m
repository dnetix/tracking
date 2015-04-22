function testing2
    a = imaqhwinfo;
    [camera_name, camera_id, format] = getCameraInfo(a);
    vid = videoinput(camera_name, camera_id, format);

    % Set the properties of the video object
    set(vid, 'FramesPerTrigger', Inf);
    set(vid, 'ReturnedColorspace', 'rgb')
    vid.FrameGrabInterval = 5;

    %start the video aquisition here
    start(vid)
    
    frame = figure('Visible', 'off');
%     data = imread('palette.png');
    a = [255, 0, 0];
    showBoxes = true;
    score = 0;
    maxFrames = 200;
    
    btn1 = uicontrol('Style', 'pushbutton', 'String', 'Change',...
        'Position', [100 10 50 20],...
        'Callback', @changeColor);
    btn2 = uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [200 10 50 20],...
        'Callback', @stopVid);
    
%     txt = uicontrol('Style', 'text',...
%        'String', strcat('Puntaje: 0 - ', int2str(maxFrames)),...
%        'Units','pixels',...
%        'HorizontalAlignment','left',...
%        'ForegroundColor', [0, 0, 1],...
%        'FontSize', 24,...
%        'Position', [20 10 250 40]);
    
    frame.Visible = 'on';
    
    A = CirclesClass(vid.VideoResolution, 6);
    
    while(vid.FramesAcquired <= maxFrames)
    
        % Get the snapshot of the current frame
        data = getsnapshot(vid);
        % Turns the video to make it more friendly
        data = flip(data, 2);
        % Now to track red objects in real time
        % we have to subtract the color component
        % from the grayscale image to extract the red components in the image.

        regions = getRegionFromImageV2(data, a);

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
%         txt.String = puntaje;
    end
    
    stop(vid);
    
    function changeColor(source, callback)
        a = impixel(data);
    end
    function stopVid(source, callback)
        stop(vid);
    end
end