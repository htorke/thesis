clear;
dl = 0.001;
radius = 0.15;
[x,y] = meshgrid(-0.7:dl:0.7);
n=1000;
strehl = zeros(1,n+1);
strehl_ff = zeros(1,n+1);
theoretical = zeros(1,n+1);
mask = (x>-2*radius) & (x<2*radius) & (y>-2*radius*sin(pi/3)) & (y<2*radius*sin(pi/3));
   
for sr = 0:n
    intensity = zeros(size(x,1),size(x,2));
    apertures = intensity;

    [i_sub,m_sub] = gauss(x,y,radius,radius,0,sr/n); 
   intensity = intensity + i_sub;
   apertures = apertures + m_sub;
   [i_sub,m_sub] = gauss(x,y,radius,-radius,0,sr/n);
   intensity = intensity + i_sub;
   apertures = apertures + m_sub;
   [i_sub,m_sub] = gauss(x,y,radius,0,2*radius*sin(pi/3),sr/n);
   intensity = intensity + i_sub;
   apertures = apertures + m_sub;
   [i_sub,m_sub] = gauss(x,y,radius,0,-2*radius*sin(pi/3),sr/n);
   intensity = intensity + i_sub;
   apertures = apertures + m_sub;
   [i_sub,m_sub] = gauss(x,y,radius,-2*radius,2*radius*sin(pi/3),sr/n);
   intensity = intensity + i_sub;
   apertures = apertures + m_sub;
   [i_sub,m_sub] = gauss(x,y,radius,-2*radius,-2*radius*sin(pi/3),sr/n);
   intensity = intensity + i_sub;
   apertures = apertures + m_sub;
   [i_sub,m_sub] = gauss(x,y,radius,2*radius,2*radius*sin(pi/3),sr/n);
   intensity = intensity + i_sub;
   apertures = apertures + m_sub;
   [i_sub,m_sub] = gauss(x,y,radius,2*radius,-2*radius*sin(pi/3),sr/n);
   intensity = intensity + i_sub;
   apertures = apertures + m_sub;

   %Incident field
   field_i = sqrt(intensity);
   %Tiled field
   field_t = field_i.*mask;
   %Aperture field
   field_o = field_t .*apertures;
   
   equivalent_intensity = apertures*sum(sum(field_i))/sum(sum(mask));
   equivalent_field = sqrt(equivalent_intensity);
   field_f = fft2(field_t);
   equivalent_f = fft2(equivalent_field);
   strehl_ff(sr+1) = (abs(field_f(1,1))/abs(equivalent_f(1,1)))^2;
   strehl(sr+1) = (sum(sum(field_o))/(sum(sum(equivalent_field))))^2;
   theoretical(sr+1) = (sr/n).^2.*(1-2*exp(-0.25*(sr/n).^-2) + exp(-0.5*(sr/n).^-2));
   
end

subplot(1,3,1)
plot(0:1/n:1,strehl_ff);
title('Fourier Simulated Result')
xlabel('sigma/radius')
ylabel('Strehl')

subplot(1,3,2)
plot(0:1 /n:1,strehl);
title('Efficient Simulated Result')
xlabel('sigma/radius')
ylabel('Strehl')

subplot(1,3,3)
plot(0:1/n:1,theoretical);
title('Theoretical Result')
xlabel('sigma/radius')
ylabel('Strehl')