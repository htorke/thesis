function [ cn_2 ] = cerro_pachon( height_m )
%Cerro_Pachon 
%   Generates Cn^2 parameter for a given height following the atmospheric
%   measurements fr

h0 = 30;
A0 = 4.5e-15;
h1 = 500;
A1 = 5e-17;

cn_2 = A0*exp(-height_m/h0) + A1*exp(-height_m/h1);

end

