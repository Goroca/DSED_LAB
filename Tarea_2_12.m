%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TAREA 2.12
% Alejandro Ramos y Carlos Gómez
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cargamos fichero de audio.
[data,fs]=audioread('haha.wav');
plot(data)
pause(1)

% Generamos fichero con el formato de la placa.
file=fopen('sample_in.dat','w');
fprintf(file,'%d\n',round(data.*127));
% FIN TAREA 2.12