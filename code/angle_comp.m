clear;
%1 Lens
array_diameter_n = 1;

%Spatial Resolution
dl = 5e-7;

illumination = 'gaus';

aberration = 'Run3_x-221.604848_y0.000000_z0.000000_f497.732639_d25.400000.txt';
%aberration = 'Run6_x-133.367059_y0.000000_z0.000000_f497.732639_d25.400000.txt';
%aberration = 'Run9_x-52.313808_y0.000000_z0.000000_f497.732639_d25.400000.txt';
%aberration = 'Run61_x188.917920_y105.796338_z0.000000_f497.732639_d25.400000.txt';
dx = 188.917920e-3;
dy = 105.796338e-3;
dz = 0;
efl = 497.732639e-3;
lens_diameter = 25.4e-3;
rho = 360*sqrt(atan2(dy,efl).^2 + atan2(dx,efl).^2)/2/pi
phi = 360*atan2(atan2(dy,efl),atan2(dx,efl))/2/pi

[x,y] = meshgrid(-(array_diameter_n)*lens_diameter/20:dl:(array_diameter_n)*lens_diameter/20);

tiltap = lens(x,y,0,0,lens_diameter,aberration,45,rho,phi,'tilt');
straightap = lens(x,y,0,0,lens_diameter,aberration,45,0,0,'tilt');

[tfield,xt,yt] = gaussian_lens(x,y,0,0,lens_diameter/2,0.447,dl,dx,dy,dz,45,rho,phi,illumination);
[sfield,xs,ys] = gaussian_lens(x,y,0,0,lens_diameter/2,0.447,dl,dx,dy,dz,45,0,0,illumination);

tilt = tiltap.*tfield.*round(sqrt(x.^2 + y.^2) < lens_diameter/40);
straight = straightap.*sfield.*round(sqrt(x.^2 + y.^2) < lens_diameter/40);

subplot(1,2,1);
imagesc(imag(tilt));

subplot(1,2,2);
imagesc(imag(straight));
       
%abs(sum(sum(tilt)))
%abs(sum(sum(straight)))
%abs(sum(sum(straight)))/abs(sum(sum(tilt)))
%max(max(abs(fft2(tilt))))
%max(max(abs(fft2(straight))))


%max(max(abs(fft2(straight))))/max(max(abs(fft2(tilt))))
abs(sum(sum(straight/dl/dl)))/abs(sum(sum(tilt)))