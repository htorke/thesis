function [S, S_Ideal] = lens_array(run_index)

%Defined Parameters
%30 milimeter lens diameter
array_diameter_n = 7;
lens_diameter = 30e-3;
%Spatial Resolution
dl = 1e-3;

n = 0;
w = waitbar(n,'Evaluating array');

%Derived Parameters
side_length_n = (array_diameter_n + 1)/2;
array_n = array_diameter_n^2 - side_length_n*(side_length_n-1);

%Calculate Ideal Strehl
fill_factor = array_n*lens_diameter*lens_diameter/(lens_diameter*array_diameter_n)/(lens_diameter*array_diameter_n);
[e,p] = gaussian_lens;
S_gauss = strehl(e,p,0.03,0.0001);
S_Ideal = fill_factor * S_gauss;


[x,y] = meshgrid(-(array_diameter_n+1)*lens_diameter/2:dl:(array_diameter_n+1)*lens_diameter/2);
field = zeros(size(x,1));
aperture = zeros(size(x,1));
power = 0;



[aberration,dx,dy,dz] = fetch_data(run_index);

%Generate Hex
for i=-(array_diameter_n-1)/2:(array_diameter_n-1)/2
   for j = -(array_diameter_n-abs(i)-1)/2:(array_diameter_n-abs(i)-1)/2
       [sub_f,sub_p] = gaussian_lens(x-lens_diameter*j,y-2*(lens_diameter/2)*sin(pi/3)*i,lens_diameter/2,0.447,dl,-dx,-dy,dz);
       field = field + sub_f;
       power = power + sub_p;
       aperture = aperture + lens(x-lens_diameter*j,y-2*(lens_diameter/2)*sin(pi/3)*i,lens_diameter,aberration);
       n = n + 1;
       waitbar(n/array_n,w,'Evaluating array');
   end
end

close(w);

%Plot Hex Grid
subplot(1,3,1)
imagesc(x(1,:),y(:,1),field);
title('Illumination Array')

%Plot sub apertures
subplot(1,3,2)
imagesc(x(1,:),y(:,1), imag(aperture));
title('Aperture Array')

%Plot equivalent aperture
subplot(1,3,3)
imagesc(x(1,:),y(:,1), abs(fftshift(fft2(field.*aperture))).^2);
title('Far Field')

S = strehl(field.*aperture,power,array_diameter_n*lens_diameter,dl);