function [ r ] = closestRange(center, range)
%CLOSESTRANGE Find the closest element to the center
%   Range must be ordered and be incremental
    if ~isempty(range) > 0
        r = range(1);
        if (center - r) > 0
            minor = true;
            i = 1;
            while i <= length(range) && minor
                r = range(i);
                if (center - r) <= 0
                    minor = false;
                end
                i = i + 1;
            end
        end
    else
        error('Debe contener elementos el arreglo')
    end
end

