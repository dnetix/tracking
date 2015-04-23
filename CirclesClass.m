% CirclesClass
% Procesamiento Digital de Imagenes
% Por: Diego Calle - dnetix@gmail.com
%     Estudiante de Ingenieria de Sistemas
%     UdeA
classdef CirclesClass
    %CIRCLESCLASS Clase que se encarga de administrar los "Globos" que
    %apareceran en la pantalla, controlando la cantidad, el movimiento y
    %las colisiones
    
    properties
        items
        index
        collisions
        maxCircles
        width
        height
    end
    
    methods
        % Constructor de la clase
        function obj = CirclesClass(resolution, maxCircles)
            obj.maxCircles = maxCircles;
            obj.width = resolution(1);
            obj.height = resolution(2);
        end
        %% NEXT
        % Se llama para continuar al proximo frame, basicamente se encarga
        % de bajar el elemento por el eje y y comprobar si se salen del
        % marco, en caso tal se elimina y se crea uno nuevo
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
        %% ADD
        % Añade un nuevo vector [x,y,r] declarando las posiciones x, y y
        % radio de un nuevo circulo a crear
        function obj = add(obj, array)
            [n, m] = size(array);
            if n == 1 && m == 3
                obj.items = [obj.items; array];
            else
                error('Dimensiones de circulo incorrectas')
            end
        end
        %% REMOVE
        % De acuerdo al indice de las posiciones de los vectores [x,y,r]
        % elimina el vector que corresponda con esa posicion
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
        %% COUNT
        % Retorna la cuenta de el numero de circulos que se encuentran en
        % la clase
        function r = count(obj)
            [n, ~] = size(obj.items);
            r = n;
        end
        %% CXR
        % Devuelve un vector creado con la consecucion de las posiciones en
        % el eje x de cada circulo
        function cxr = cxr(obj)
            cxr = obj.items(:,1)';
        end
        %% CYR
        % Devuelve un vector creado con la consecucion de las posiciones en
        % el eje y de cada circulo
        function cyr = cyr(obj)
            cyr = obj.items(:,2)';
        end
        %% CRR
        % Devuelve un vector creado con la consecucion de los radios de
        % cada circulo
        function crr = crr(obj)
            crr = obj.items(:,3)';
        end
        %% CHECKCOLISION
        % Recibe como parametro las regiones de color con las cuales se
        % comparara si hubo una colision
        function obj = checkColision(obj, regions)
            collisioned = [];
            count = obj.count; % Numero de circulos en el momento
            for i = 1:count
                active = obj.items(i, :); % circulo a comparar
                [x, y, r, rangeX, rangeY] = rearrange(active);
                j = 1; checking = true; % Variables para el ciclo
                while j <= length(regions) && checking
                    % Dado que regions es una estructura de datos obtengo
                    % la que se encuentre en al posicion j
                    region = regions(j);
                    % Obtengo el rango de x de la caja de la region
                    rRX = (round(region.Centroid(1) - (region.Centroid(1) - region.BoundingBox(1))):round(region.Centroid(1) + (region.Centroid(1) - region.BoundingBox(1))));
                    % Realizo una interseccion entre el rango de x del
                    % circulo y el rango de x de la caja de la region
                    xIntersect = intersect(rangeX, rRX);
                    % Compruebo si hay en la interseccion de x
                    if ~isempty(xIntersect)
                        % Dado que los hay entonces empiezo a comprobar en
                        % el eje y, hallo el rango de y para la caja de la
                        % region
                        rRY = round(region.Centroid(2) - (region.Centroid(2) - region.BoundingBox(2))):round(region.Centroid(2) + (region.Centroid(2) - region.BoundingBox(2)));
                        % Interseccion entre estos valores
                        yIntersect = intersect(rangeY, rRY);
                        % Compruebo si hay valores en la interseccion
                        if ~isempty(yIntersect)
                            % Obtengo el valor mas cercano al centro de la
                            % circunferencia, de los que se intersectan con
                            % la caja de la ragion
                            closest = closestRange(x, xIntersect);
                            % Calculo la distancia en el eje y con base en
                            % punto x mas cercano al centro de la
                            % circunferencia
                            distanceY = round(sqrt((r^2) - (round((x - closest)))^2));
                            % Compruebo si se intersecta en el rango real
                            % de y
                            yIntersect = intersect((y - distanceY):(y + distanceY), rRY);
                            % Si se intersectan, hay una colision
                            if ~isempty(yIntersect)
                                % En un arreglo adiciono el valor de la
                                % posicion del circulo que colisiono para
                                % eliminarlo
                                collisioned = [collisioned; i];
                                % Dejo de comprobar para este circulo que
                                % ya colisiono
                                checking = false;
                            end
                            
                        end
                    end
                    % Incremento el valor de j que se usa para cargar la
                    % proxima region
                    j = j + 1;
                end
            end
            % El numero de colisiones esta dado en este punto por el numero
            % de items que tenga el vector collisioned
            obj.collisions = length(collisioned);
            % Itero entre los colisionados para removerlos 1 a 1
            for i = 1:obj.collisions
                % Borro el circulo que ha colisionado
                obj = obj.remove(collisioned(i));
                % Dado que se trata de posiciones en un vector al haber
                % eliminado uno todas las posiciones decrementan en 1
                collisioned = collisioned - 1;
            end
        end
    end
    
end