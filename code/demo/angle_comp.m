clear;
%1 Lens
array_diameter_n = 1;

%Spatial Resolution
dl = 1e-5;

illumination = 'gaus';

aberration = 'Run10_x-26.085062_y0.000000_z0.000000_f497.732639_d25.400000.txt';
dx = -26.085062e-3;
dy = 0;
dz = 0;
efl = 497.732639e-3;
lens_diameter = 25.4e-3;
rho = 360*sqrt(atan2(dy,efl).^2 + atan2(dx,efl).^2)/2/pi;
phi = 360*atan2(atan2(dy,efl),atan2(dx,efl))/2/pi;

[x,y] = meshgrid(-(array_diameter_n)*lens_diameter/2:dl:(array_diameter_n)*lens_diameter/2);

ap = lens(x,y,lens_diameter,2*(lens_diameter/2)*sin(pi/3),lens_diameter,aberration,90,rho,phi);