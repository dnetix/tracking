%% BallonsGame
% Contiene la logica para la visualizacion y funcionamiento del juego,
% espera un objeto de video
%
% Procesamiento Digital de Imagenes
% Por: Diego Calle - dnetix@gmail.com
%     Estudiante de Ingenieria de Sistemas
%     UdeA
function ballonsGame(vid)
    % No muestro la ventana por defecto
    frame = figure('Visible', 'off');
    % Color inicial a rastrear, un rojo vivo
    color2Track = [255, 0, 0];
    % Define si se muestran las regiones capturadas que contengan el color
    showBoxes = true;
    % Puntaje inicial
    score = 0;
    % Tolerancia inicial aceptada
    variance = 10;
    
    % Creo la interfaz de usuario con un boton para cambiar el color a
    % seguir, el boton de finalizar, el slider que modifica la tolerancia y
    % el puntaje
    btnChangeUI = uicontrol('Style', 'pushbutton', 'String', 'Cambiar Color',...
        'Position', [10 10 120 30],...
        'Callback', @changeColor);
    btnEndUI = uicontrol('Style', 'pushbutton', 'String', 'Finalizar',...
        'Position', [140 10 120 30],...
        'Callback', @stopGame);
    varianceUI = uicontrol('Style', 'slider',...
        'Min', 0, 'Max', 120, 'Value', 10,...
        'Position', [280 10 80 30],...
        'Callback', @changeVariance);
    scoreUI = uicontrol('Style', 'text',...
       'String', strcat('Explotados: 0'),...
       'Units','pixels',...
       'HorizontalAlignment','left',...
       'ForegroundColor', [0, 0, 1],...
       'FontSize', 24,...
       'Position', [380 10 220 40]);
    % Una vez creados los items de interfaz de usuario muestro la ventana    
    frame.Visible = 'on';
    
    % Inicio la clase encargada de manejar los circulos y determinar las
    % colisiones, con el tamaño de la imagen y el numero maximo de globos
    % en cualquier momento
    A = CirclesClass(vid.VideoResolution, 6);
    % Por defecto se inicia esta variable como verdadero para jugar
    playing = true;
    % Loop mientras que se cambie la variable haciendo clic en finalizar
    % para el juego.
    while(playing)
    
        % Obtengo una captura de la imagen en el momento
        data = getsnapshot(vid);
        % Invierto horizontalmente la informacion para generar un efecto
        % espejo
        data = flip(data, 2);
        % Con esta informacion obtengo las regiones que contengan el color
        % o una variacion del mismo dependiendo de la tolerancia o varianza
        regions = getRegionsColor(data, color2Track, variance);
        % Muestro la imagen al usuario
        imshow(data)
        % Detengo el pintado de objetos en la figura para añadir los
        % "globos"
        hold on
        % Le pido a la clase de circulos detectar colisiones entre los
        % circulos que contiene y las regiones que se han obtenido
        A = A.checkColision(regions);
        % Sumo el puntaje con el numero de colisiones determinado por la
        % clase, si no hubiere, seria una suma a 0 por lo que se mantendria
        % igual
        score = score + A.collisions;
        % Si la variable se encuentra en verdadero muestro en la captura
        % los marcos que muestran las regiones que contienen el color
        % seleccionado
        if showBoxes
            displayRegions(regions);
        end
        % Si la clase tiene circulos en el momento los dibujo en pantalla,
        % caso contrario lo ignora
        if A.count > 0
            drawCircle(A.cxr, A.cyr, A.crr, 'facealpha', 0.8);
        end
        % Marca el proximo para para la clase, haciendo que esta incremente
        % las variables en y de los globos y detecte si algunos ya se
        % salieron del marco para borrarlos
        A = A.next;
        % Remuevo la detencion
        hold off
        % Actualizo el texto a mostrar con el puntaje
        puntaje = strcat('Puntaje: ', int2str(score));
        % Modifico en la variable que contiene el texto mostrado al usuario
        scoreUI.String = puntaje;
    end
    %% Cambiar Color
    % Como no es necsario el source y el callback omito las variables, esta
    % funcion es ejecutada cuando se presiona el boton "Cambiar Color" que
    % permite que el usuario elija un nuevo pixel para el color.
    function changeColor(~, ~)
        % Pido que el usuario seleccione un pixel y cargo sus valores RGB
        % en la variable a comparar.
        color2Track = impixel(data);
    end
    %% Stop Game
    % Cierra el ciclo del juego para terminarlo.
    function stopGame(~, ~)
        playing = false;
    end
    %% Change Variance
    % Toma el valor del slider que ha movido el usuario y se lo asigna a la
    % tolerancia
    function changeVariance(source, ~)
        variance = round(source.Value);
    end
end