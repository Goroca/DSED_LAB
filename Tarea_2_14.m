%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TAREA 2.14
% Alejandro Ramos y Carlos Gómez
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cargamos fichero de audio.
[data,fs]=audioread('haha.wav');
plot(data)
title('Señal en el tiempo')
pause

N=1024; % Nº de puntos de la FFT para la representación.
% Coeficientes del filtro.
b=[0.5,-0.5,1.0,-0.5,0.5];
a=[1,0,0,0,0];
[h,f]=freqz(b,a,N,fs);
semilogy(f,abs(h),'g')
title('Filtro test')
pause

% Filtro paso bajo.
bpb=[0.039,0.2422,0.4453,0.2422,0.039];
apb=[1,0,0,0,0];
[hpb,f]=freqz(bpb,apb,N,fs);
semilogy(f,abs(hpb),'b')
title('Filtro paso bajo')
pause

% Filtro paso alto
bpa=[-0.0078,-0.2031,0.6015,-0.2031,-0.0078];
apa=[1,0,0,0,0];
[hpa,f]=freqz(bpa,apa,N,fs);
semilogy(f,abs(hpa),'r')
title('Filtro paso alto')
pause
%return


% Filtramos y reproducimos fichero de entrada y salida del filtro.
% Datos con precisión real.
sound(data)
pause
dataf=filter(b,a,data);
sound(dataf)
pause
data_pb=filter(bpb,apb,data);
sound(data_pb)
pause
data_pa=filter(bpa,apa,data);
sound(data_pa)
pause
%return

% Comparación de los datos con preción real de los filtrados con la placa.
vhdlout=load('C:\Users\usuario\DSED_LAB\DSED_LAB.sim\sim_1\behav\sample_out.dat')/127;
%vhdlout=load('C:\Users\Carlos\Vivado-WorkSpace\DSED_LAB\DSED_LAB.sim\sim_1\behav\sample_out.dat')/127;

sound(vhdlout)

data_filt=data_pb;
error=data_filt-vhdlout;

plot(data_filt)
title('Salida del LPF generado con MATLAB')
pause
plot(vhdlout)
title('Salida del LPF generado con VHDL')
pause
plot(error)
title('Error respecto a precisión real')
return