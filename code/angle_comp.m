clear;
%1 Lens
array_diameter_n = 1;

%Spatial Resolution
dl = 2e-6;

illumination = 'gaus';

aberration = 'Run9_x-52.313808_y0.000000_z0.000000_f497.732639_d25.400000.txt';
dx = -52.313808e-3;
dy = 0;
dz = 0;
efl = 497.732639e-3;
lens_diameter = 25.4e-3;
rho = 360*sqrt(atan2(dy,efl).^2 + atan2(dx,efl).^2)/2/pi
phi = 360*atan2(atan2(dy,efl),atan2(dx,efl))/2/pi;

[x,y] = meshgrid(-(array_diameter_n)*lens_diameter/2:dl:(array_diameter_n)*lens_diameter/2);

tiltap = lens(x,y,0,0,lens_diameter,aberration,45,rho,phi,'tilt');
straightap = lens(x,y,0,0,lens_diameter,aberration,45,0,0,'none');

tfield = gaussian_lens(x,y,0,0,lens_diameter/2,0.447,dl,dx,dy,dz,45,rho,phi,illumination);
sfield = gaussian_lens(x,y,0,0,lens_diameter/2,0.447,dl,dx,dy,dz,45,0,0,illumination);

tilt = tiltap.*tfield;
straight = straightap.*sfield;

subplot(1,2,1);
imagesc(imag(tilt));

subplot(1,2,2);
imagesc(imag(straight));
       
%abs(sum(sum(tilt)))
%abs(sum(sum(straight)))

max(max(abs(fft2(tilt))))
max(max(abs(fft2(straight))))