function [Reg_sep,n]=regdiagSISOsep(Reg)
% function [Reg_sep]=regdiagSISOsep(Reg)
%Función para separar los estados del sistema diagonal en subespacios caso
%1º) Se obtiene la descomposición en fracciones simples (caso SISO)
%2º) Se ordenan los estados de más rápido a menos rápido
%3º) Se separan todos los subespacio
%Cada subespacio es independiente del resto
% tendrá como entradas el resto de subespacios
%Reg: Sistema discreto a separar (tipo tf)
%Reg_sep. estructura con todos los subsistemas Red_sep.Sx (con x=0,1,2,...)
%n: número de subespacios (sin incluir acoplamiento directo)
%NOTA: La matriz D irá al 1º subespacio (Reg_sep.S0)
RegSS=ss(Reg);
m=size(RegSS.B,2);%Número de entradas
if m>1
    disp('Hay más de 1 entrada')
    return;
end
sal=size(RegSS.C,1);%Número de salidas
if sal>1
    disp('Hay más de 1 salida')
    return;
end

T=Reg.Ts;%Periodo de muestreo base
[num den]=tfdata(Reg,'v');
[r p k]=residue(num,den)
Reg_Sep.S0=ss(0,0,0,5,T);%El acoplamiento directo
n=0;
for i=1:length(p)
    i
    %Falta polo doble 
    n=n+1;
    if abs(imag(p(i))) < 1e-8 %Polo real
        eval(['Reg_sep.S' num2str(i) '= ss(tf(r(i),[1 -p(i)],T));'])
    else %Polo complejo
        ni=real([r(i)+r(i+1) -r(i)*p(i+1)-r(i+1)*p(i)])
        di=real([1 -(p(i)+p(i+1)) p(i)*p(i+1)])
        eval(['Reg_sep.S' num2str(i) '= ss(tf(ni, di,T));'])
        i=i+1;
    end
end
