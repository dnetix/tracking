function [ h ] = drawCircle(x,y,r,varargin)
% Dibuja circulos en pantalla con base en unas coordenadas y un radio
%
%% Syntax
%  drawCircle(x,y,r)
%  drawCircle(...,'points',numberOfPoints)
%  drawCircle(...,'rotation',degreesRotation)
%  drawCircle(...,'ColorProperty',ColorValue)
%  drawCircle(...,'LineProperty',LineValue)
%  h = drawCircle(...)
%
%% Description
%
% drawCircle(x, y, r) dibuja circulos de radio r centrado en las
% coordenadas expresadas por x,y.
% x y y pueden ser escalares o vectores pero en este ultimo caso las
% dimensiones deben coincidir
%
% drawCircle(...,'points',numberOfPoints) permite especificar cuantos usar
% para el borde de cada circulo, el valor por defecto es 1000 pero puede
% ser incrementado para mejorar la resolucion o disminuidos. ej 4 dibujaria
% un cuadro, 5 un pentagono, etc.
%
% drawCircle(...,'rotation',degreesRotation) rota la forma por un grado de
% rotacion dado, es inutil para circulos pero funcional para otras formas.
%
% drawCircle(...,'ColorProperty',ColorValue) permite la declaracion de
% 'facecolor' o 'facealpha' como par de valores
%
% drawCircle(...,'LineProperty',LineValue) permite la declaracion de
% atributos como  'edgecolor', 'linewidth', etc.
%
% h = drawCircle(...) retorna el manejador de las figuras
%
%
%% EXAMPLES:
%
% Ejemplo 1:
% drawCircle(5,10,3)
%
% % Ejemplo 2:
% x = 2:7;
% y = [5,15,12,25,3,18];
% r = [3 4 5 5 7 3];
% drawCircle(x,y,r)
%
% % Ejemplo 3:
% figure
% drawCircle(1:10,5,2)
%
% % Ejemplo 4:
% figure
% drawCircle(5,15,1:5,'facecolor','none')
%
% % Ejemplo 5:
% figure
% drawCircle(5,10,3,'facecolor','green')
%
% % Ejemplo 6:
% figure
% h = drawCircle(5,10,3,'edgecolor',[.5 .2 .9])
%
% % Ejemplo 7:
% lat = repmat((10:-1:1)',1,10);
% lon = repmat(1:10,10,1);
% r = .4;
% figure
% h1 = drawCircle(lon,lat,r,'linewidth',4,'edgecolor','m','facecolor',[.6 .4 .8]);
% hold on;
% h2 = drawCircle(1:.5:10,((1:.5:10).^2)/10,.12,'edgecolor','k','facecolor','none');
% axis equal

%% Comprobar entradas:

assert(isnumeric(x),'Input x must be numeric.')
assert(isnumeric(y),'Input y must be numeric.')
assert(isnumeric(r),'Input r must be numeric.')

if ~isscalar(x) && ~isscalar(y)
    assert(numel(x)==numel(y),'If neither x nor y is a scalar, their dimensions must match.')
end
if ~isscalar(x) && ~isscalar(r)
    assert(numel(x)==numel(r),'If neither x nor r is a scalar, their dimensions must match.')
end
if ~isscalar(r) && ~isscalar(y)
    assert(numel(r)==numel(y),'If neither y nor r is a scalar, their dimensions must match.')
end

%% Parse inputs:

% Define number of points per circle:
tmp = strcmpi(varargin,'points')|strcmpi(varargin,'NOP')|strcmpi(varargin,'corners')|...
    strncmpi(varargin,'vert',4);
if any(tmp)
    NOP = varargin{find(tmp)+1};
    tmp(find(tmp)+1)=1;
    varargin = varargin(~tmp);
else
    NOP = 1000; % 1000 points on periphery by default
end

% Define rotation
tmp = strncmpi(varargin,'rot',3);
if any(tmp)
    rotation = varargin{find(tmp)+1};
    assert(isnumeric(rotation)==1,'Rotation must be numeric.')
    rotation = rotation*pi/180; % converts to radians
    tmp(find(tmp)+1)=1;
    varargin = varargin(~tmp);
else
    rotation = 0; % no rotation by default.
end

% Be forgiving if the user enters "color" instead of "facecolor"
tmp = strcmpi(varargin,'color');
if any(tmp)
    varargin{tmp} = 'facecolor';
end

%% Begin operations:

% Make inputs column vectors:
x = x(:);
y = y(:);
r = r(:);
rotation = rotation(:);

% Determine how many circles to plot:
numcircles = max([length(x) length(y) length(r) length(rotation)]);

% Create redundant arrays to make the plotting loop easy:
if length(x)<numcircles
    x(1:numcircles) = x;
end

if length(y)<numcircles
    y(1:numcircles) = y;
end

if length(r)<numcircles
    r(1:numcircles) = r;
end

if length(rotation)<numcircles
    rotation(1:numcircles) = rotation;
end

% Define an independent variable for drawing circle(s):
t = 2*pi/NOP*(1:NOP);

% Query original hold state:
holdState = ishold;
hold on;

% Preallocate object handle:
h = NaN(size(x));

% Plot circles singly:
for n = 1:numcircles
    h(n) = fill(x(n)+r(n).*cos(t+rotation(n)), y(n)+r(n).*sin(t+rotation(n)),'',varargin{:});
end

% Return to original hold state:
if ~holdState
    hold off
end

% Delete object handles if not requested by user:
if nargout==0
    clear h
end

end

