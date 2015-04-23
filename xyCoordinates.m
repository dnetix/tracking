function [ x,y ] = xyCoordinates(index, m)
%POSITION Summary of this function goes here
%   Detailed explanation goes here
    x = mod(index, m);
    y = floor(index / m) + 1;
end

