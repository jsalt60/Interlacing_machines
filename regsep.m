function [Reg_sep]=regsep(Reg,n)
% function [Reg_sep]=regsep(Reg,n)
%Función para separar los estados de un sistema en subespacio
%Cada subespacio tendrá como entradas el resto de subespacios
%Reg: Sistema a separar (tipo ss)
%n: vector con la dimensión de cada subespacio
%Reg_sep. estructura con todos los subsistemas Red_sep.Sx (con x=1,2,...)
%NOTA: la matriz C y D de Reg debe añadirse después

nT=size(Reg.A,1);%Número total de estados.

if sum(n) ~= nT
    disp('La dimensión de los subespacio no coincide con el número de estados del sistema')
    return;
end
m=size(Reg.B,2);%Número de entradas

p=length(n);%Número de partes a separar
T=Reg.Ts;%Periodo de muestreo base

for k=1:p
    if k==1
        f=1:n(k);
    else
        f=sum(n(1:k-1))+1:sum(n(1:k));%Filas del bloque k
    end;

    if k==1
        ca=[];%Primer bloque no tiene columnas anteriores
    else
        ca=1:f(1)-1;%columnas anteriores del bloque k
    end;
    if k==p
        cp=[];%último bloque no tiene columnas posteriores
    else
        cp=f(end)+1:nT;%columnas posteriores del bloque k
    end;
    
    A=Reg.A(f,f);
    B=[Reg.B(f,:) Reg.A(f,ca) Reg.A(f,cp)];
    C=eye(length(f));
    D=zeros(length(f),m+nT-n(k));
    eval(['Reg_sep.S' num2str(k) '= ss(A,B,C,D,T);'])
end