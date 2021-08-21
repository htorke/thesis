clear;
run_index = 1000; 
    n = 1;
%Defined Parameters
array_diameter_n = n;
%Spatial Resolution
dl = 5e-5;
    theta = 90;  
   rho = 30; 
   phi = 0;  
    shape = 'tile';


[aberration1,dx,dy,dz,efl,lens_diameter] = fetch_data(run_index);
[aberration2,dx,dy,dz,efl,lens_diameter] = fetch_data(1);
[x,y] = meshgrid(-(array_diameter_n+1)*lens_diameter/2:dl:(array_diameter_n+1)*lens_diameter/2);
field = zeros(size(x,1));
aperture = zeros(size(x,1));
power = 0;

ap1 = lens_oslo(x,y,0,0,lens_diameter,aberration1,theta,rho,phi,'none');
opd1 = zernike(x*sqrt(3)/2,y,lens_diameter/2,aberration1,'none');

ap2 = lens_oslo(x,y,0,0,lens_diameter,aberration2,theta,rho,phi,'none');
opd2 = zernike(x,y,lens_diameter/2,aberration2,'none');

diff = ap1-ap2;

subplot(1,2,1)
imagesc(opd1)
view(0,270);
subplot(1,2,2)
imagesc(opd2)
view(0,270);