classdef CirclesClass
    %CIRCLESCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        items
        index
        collisions
        maxCircles
        width
        height
    end
    
    methods
        function obj = CirclesClass(resolution, maxCircles)
            obj.maxCircles = maxCircles;
            obj.width = resolution(1);
            obj.height = resolution(2);
        end
        function obj = next(obj)
            if obj.count < obj.maxCircles
                obj = obj.add([round((obj.width-1).* rand()), 1, round(((obj.width / 4)-50).* rand())]);
            end
            toRemove = 0;
            for i = 1:obj.count
                actual = obj.items(i,:);
                if (actual(2) - actual(3)) > obj.height
                    toRemove = i;
                end
            end
            if toRemove
                obj = obj.remove(toRemove);
            end
            obj.items = [obj.items(:,1), obj.items(:,2) + 10, obj.items(:,3)];
        end
        function obj = add(obj, array)
            [n, m] = size(array);
            if n == 1 && m == 3
                obj.items = [obj.items; array];
            else
                error('Dimensiones de circulo incorrectas')
            end
        end
        function obj = remove(obj, index)
            if index <= obj.count
                if index == 1
                    range = 2:obj.count;
                else if index == obj.count
                        range = 1:(obj.count - 1);
                    else
                        range = [1:(index-1),(index+1):obj.count];
                    end
                end
                obj.items = obj.items(range,:,:);
            end
        end
        function r = count(obj)
            [n, ~] = size(obj.items);
            r = n;
        end
        % Gets the x coordinates as a vector
        function cxr = cxr(obj)
            cxr = obj.items(:,1)';
        end
        % Gets the y coordinates as a vector
        function cyr = cyr(obj)
            cyr = obj.items(:,2)';
        end
        % Gets the radius as a vector
        function crr = crr(obj)
            crr = obj.items(:,3)';
        end
        % Detects colisions between this circles and the bounding boxes
        function obj = checkColision(obj, regions)
            collisioned = [];
            count = obj.count;
            for i = 1:count
                active = obj.items(i, :);
                [x, y, r, rangeX, rangeY] = rearrange(active);
                j = 1;
                checking = true;
                while j < length(regions) && checking
                    region = regions(j);
                    xIntersect = intersect(rangeX, round(region.Centroid(1) - (region.Centroid(1) - region.BoundingBox(1))):round(region.Centroid(1) + (region.Centroid(1) - region.BoundingBox(1))));
                    % Check if the colision exists on the x axis
                    if ~isempty(xIntersect)
                        % Now with this one check the y axis
                        activeRangeY = round(region.Centroid(2) - (region.Centroid(2) - region.BoundingBox(2))):round(region.Centroid(2) + (region.Centroid(2) - region.BoundingBox(2)));
                        yIntersect = intersect(rangeY, activeRangeY);
                        if ~isempty(yIntersect)
                            % Now with this one really check the y axis
                            closest = closestRange(x, xIntersect);
                            
                            % Calculate distance from center
                            distanceY = round(sqrt((r^2) - (round((x - closest)))^2));
                            
                            yIntersect = intersect((y - distanceY):(y + distanceY), activeRangeY);
                            if ~isempty(yIntersect)
                                % A colision has been made
                                collisioned = [collisioned; i];
                                checking = false;
                            end
                            
                        end
                    end
                    j = j + 1;
                end
            end
            
            obj.collisions = length(collisioned);
            for i = 1:obj.collisions
                obj = obj.remove(collisioned(i));
                collisioned = collisioned - 1;
            end
        end
    end
    
end