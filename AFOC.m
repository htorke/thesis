%AFOC Simulation
clear;

%Defined Parameters
%30 centimeter lens diameter
array_diameter_n = 3;
lens_diameter = 28e-3;
lens_spacing = 32e-3;
%Spatial Resolution
dl = 1e-4;
%Padding ratio
padd = 1;


[x,y] = meshgrid(-(array_diameter_n+1)*lens_diameter/2:dl:(array_diameter_n+1)*lens_diameter/2);
intensity = zeros(size(x,1));

%Generate comparative ideal lens
r = sqrt((x).^2 + (y).^2);

%Aperture is a circle
equivalent_aperture = abs(r)<(lens_diameter*array_diameter_n/2);

%Generate Hex
for i=-(array_diameter_n-1)/2:(array_diameter_n-1)/2
   for j = -(array_diameter_n-abs(i)-1)/2:(array_diameter_n-abs(i)-1)/2
       intensity = intensity + (sqrt((lens_spacing*j-x).^2 +(2*(lens_spacing/2)*sin(pi/3)*i -y).^2)< lens_diameter/2).*gauss(x,y,lens_diameter/2,lens_spacing*j,2*(lens_spacing/2)*sin(pi/3)*i);
   end
end

imagesc(x(1,:),y(:,1),intensity)