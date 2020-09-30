clear;

%Defined Parameters
%30 centimeter lens diameter
array_diameter_n = 1;
lens_diameter = 30e-2;
%Spatial Resolution
dl = 1e-3;
%Padding ratio
padd = 1;


%Derived Parameters
side_length_n = (array_diameter_n + 1)/2;
array_n = array_diameter_n^2 - side_length_n*(side_length_n-1);
fill_factor = array_n*lens_diameter*lens_diameter/(lens_diameter*array_diameter_n)/(lens_diameter*array_diameter_n);
lens_area =array_n*pi*lens_diameter*lens_diameter;

[x,y] = meshgrid(-(array_diameter_n+1)*lens_diameter/2:dl:(array_diameter_n+1)*lens_diameter/2);
intensity = zeros(size(x,1));

%Generate comparative ideal lens
r = sqrt((x).^2 + (y).^2);

%Aperture is a circle
equivalent_aperture = abs(r)<(lens_diameter*array_diameter_n/2);

% %Aperture is a Hexagon
% w = lens_diameter*array_diameter_n;
% hex = abs(y)<-sqrt(3)*x+sqrt(3)*w/2&x<w/2&x>w/4;
% hex = hex+(abs(y)<sqrt(3)*x+sqrt(3)*w/2&x>-w/2&x<-w/4);
% hex = hex+(abs(y)<w*sqrt(3)/4&x<w/4&x>-w/4);
% equivalent_aperture = hex;

% %Aperture is a 2x box
% equivalent_aperture = (x>-lens_diameter/2)&(x<3*lens_diameter/2)&(y<2*(lens_diameter/2)*sin(pi/3))&(y>-2*(lens_diameter/2)*sin(pi/3));


%Generate Hex
for i=-(array_diameter_n-1)/2:(array_diameter_n-1)/2
   for j = -(array_diameter_n-abs(i)-1)/2:(array_diameter_n-abs(i)-1)/2
       intensity = intensity + gauss(x,y,lens_diameter/2,lens_diameter*j,2*(lens_diameter/2)*sin(pi/3)*i);
   end
end

%%Generate Circle bounded array
%for i=-(array_diameter_n+1)/2:(array_diameter_n+1)/2
%    for j = -(array_diameter_n+1)/2:(array_diameter_n+1)/2
%       intensity = intensity + gauss(x,y,lens_diameter/2,lens_diameter*j+mod(i,2)*lens_diameter/2,2*(lens_diameter/2)*sin(pi/3)*i);
%    end
%end
%intensity = intensity .* (sqrt(x.^2+y.^2)<(array_diameter_n*lens_diameter/2));

intensity = intensity .*equivalent_aperture;
field = sqrt(intensity);

equivalent_aperture = equivalent_aperture*sum(sum(intensity))/sum(sum(equivalent_aperture));
equivalent_field = sqrt(equivalent_aperture);


%f_space = zeros(padd*(size(x,1)-1)+1);


%Plot Hex Grid
subplot(1,2,1)
imagesc(x(1,:),y(:,1),intensity);
title('Lens Array')

%%Plot Fourier transform of test array, corresponding to Fraunhofer
%%approximation
%subplot(2,2,3)
%f_space((size(f_space,2)+1)/2-(size(x,2)-1)/2:(size(f_space,2)+1)/2+(size(x,2)-1)/2,(size(f_space,2)+1)/2-(size(x,2)-1)/2:(size(f_space,2)+1)/2+(size(x,2)-1)/2) = field;
%field_f = fft2(f_space);
%imagesc(fftshift(abs(field_f)))
%title('Lens Farfield')

%Plot equivalent aperture
subplot(1,2,2)
imagesc(x(1,:),y(:,1),equivalent_aperture);
title('Equivalent Aperture')

%%Plot Fourier of ideal aperture
%subplot(2,2,4)
%f_space((size(f_space,2)+1)/2-(size(x,2)-1)/2:(size(f_space,2)+1)/2+(size(x,2)-1)/2,(size(f_space,2)+1)/2-(size(x,2)-1)/2:(size(f_space,2)+1)/2+(size(x,2)-1)/2) = equivalent_field;
%equivalent_field_f = fft2(f_space);
%imagesc(fftshift(abs(equivalent_field_f)))
%title('Equivalent Farfield')

%(field_f(1)/equivalent_field_f(1))^2
(sum(sum(field))/sum(sum(equivalent_field)))^2
