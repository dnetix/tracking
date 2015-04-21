classdef CirclesClass
    %CIRCLESCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        items
        index
    end
    
    methods
        function obj = add(obj, array)
            [n, m] = size(array);
            if n == 1 && m == 3
                obj.items = [obj.items; array];
            else
                error('Dimensiones de circulo incorrectas')
            end
        end
        function obj = remove(obj, index)
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
    end
    
end