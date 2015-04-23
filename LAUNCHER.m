%% Launcher
% Este es el script a correr para jugar BallonsGame
% "Juego" para reventar globos mediante seguimiento de color en Matlab con
% la camara web.
%
% Procesamiento Digital de Imagenes
% Por: Diego Calle - dnetix@gmail.com
%     Estudiante de Ingenieria de Sistemas
%     UdeA
%% Logica inicial
%
% Añado la carpeta 'funcion' a las variables de Matlab, para que las
% funciones que se encuentran en esa carpeta sean accesibles a Matlab
addpath function;
% Limpio la consola y variables previas
clc; clear all;
% Obtengo la informacion de la camara web del equipo
[camera_name, camera_id, format] = getCameraInfo(imaqhwinfo);
% Cargo en una variable el objeto de captura de imagenes de camara
vid = videoinput(camera_name, camera_id, format);
% Configuro unas propiedades iniciales para la captura de video
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
% Establezco la captura de imagen cada 5 frames o cuadros de imagen
vid.FrameGrabInterval = 5;
% Inicio la captura de video
start(vid);
%% Funcion del juego
% Dentro de esta funcion se corre el juego en si
ballonsGame(vid);
%% Fin logica inicial
% Detengo la captura de video en la variable
stop(vid);
% Cierro las ventanas
close all;
% Remuevo la carpeta del path de Matlab
rmpath function;