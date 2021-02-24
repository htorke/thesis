clear;
dl = 0.0001;
[x,y] = meshgrid(-0.03:dl:0.03);
n=1000;
strehl_ff = zeros(1,n+1);
%strehl = zeros(1,n+1);
strehl_e = zeros(1,n+1);
theoretical = zeros(1,n+1);
for sr = 0:n/2
   [intensity, mask] = gauss(x,y,0.015,0,0,sr/n);
   field0 = sqrt(intensity);
   field1 = sqrt(intensity.*mask);
   
   equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
   equivalent_field = sqrt(equivalent_intensity);
   
   efficient_intensity = 2*pi*sr*sr*0.015*0.015*mask/sum(sum(mask));
   efficient_field = sum(sum(sqrt(efficient_intensity)));
   
   field1_f = fft2(field1);
   equivalent_f = fft2(equivalent_field);
   
   %strehl(sr+1) = (sum(sum(field1))/(sum(sum(equivalent_field))))^2;
   strehl_ff(sr+1) = (abs(field1_f(1))/abs(equivalent_f(1)))^2;
   strehl_e(sr+1) = strehl_2(equivalent_field,field1);%(sum(sum(field1))/(efficient_field))^2;
   theoretical(sr+1) = 8*(sr/n).^2.*(1-2*exp(-0.25*(sr/n).^-2) + exp(-0.5*(sr/n).^-2));
   %Ds\dsr = (8 (1 - 2 exp (-0.25 (n)^-2) + exp (-0.5 (n)^-2))*(n)^2)
end

subplot(1,3,1)
plot(0:1/n:1,strehl_ff);
title('Fourier Simulated Result')
xlabel('sigma/radius')
ylabel('Strehl')

subplot(1,3,2)
plot(0:1/n:1,strehl_e);
title('Efficient Simulated Result')
xlabel('sigma/radius')
ylabel('Strehl')

subplot(1,3,3)
plot(0:1/n:1,theoretical);
title('Theoretical Result')
xlabel('sigma/radius')
ylabel('Strehl')