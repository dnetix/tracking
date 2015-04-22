function [x,y,r, rx, ry] = rearrange(vector)
%REARRANGE Return the contents of a 3 items array into variables
%   [x,y,r] = rearrange(vector)
    x = vector(1);
    y = vector(2);
    r = vector(3);
    rx = x-r:x+r;
    ry = y-r:y+r;
end

