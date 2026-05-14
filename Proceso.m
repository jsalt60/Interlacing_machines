%Vehiculo
% salida yaw rate entrada steering
% El control está diseñado para considerar una velocidad lineal entre 4 y 10 m/s (circuito urbano)
% Fichero: paper2226.mat con K y Kred=balred(K,6). K es de orden 15
clear;
close all;

%System parameters
m=995;
a=1.233;
b=1.327;
Caf=41e3;
l=2.56;
Iz=1760;
Car=47e3;
g = 9.81;
%vx=6;
vx = ureal('vx',6,'Range',[4,10])
a1=m*vx*a*Caf;
A1=m*a*Caf;
a2=l*Caf*Car;
A2=a2;
b1=m*vx*Iz;
B1=m*Iz;
b2=Iz*(Caf+Car)+m*((a^2)*Caf+(b^2)*Car);
B2=b2;
b3=(Caf*Car/vx)*(l^2)*(1+((m*vx*(b*Car-a*Caf))/(Caf*Caf*(l^2))));
B3=(Caf*Car)*(l^2)*(1+((m*vx*(b*Car-a*Caf))/(Caf*Caf*(l^2))));
s=tf('s');

Planta=(a1*s+a2)/(b1*s^2+b2*s+b3)%Proceso Continuo
%analisis
disp('Polos:'),pole(Planta)
disp('Ceros:'),tzero(Planta)


%Perido de muestreo
T=10e-3;%10ms
load("paper2226.mat");
%K: regulador continuo de orden 15
%Kred: regulador continu de orden 6
Gr=c2d(K,T,'zoh');
SR_Diag=canon(Gr,'modal');
pole(SR_Diag)%Ordenador polos de mayor a menor rapidez