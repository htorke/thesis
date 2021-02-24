clear;

%Defined Parameters
%30 centimeter lens diameter
array_diameter_n = 7;
lens_diameter = 30e-3;
%Spatial Resolution
dl = 1e-4;


%Derived Parameters
side_length_n = (array_diameter_n + 1)/2;
array_n = array_diameter_n^2 - side_length_n*(side_length_n-1);
fill_factor = array_n*lens_diameter*lens_diameter/(lens_diameter*array_diameter_n)/(lens_diameter*array_diameter_n);
lens_area =array_n*pi*lens_diameter*lens_diameter;


[x,y] = meshgrid(-(array_diameter_n+1)*lens_diameter/2:dl:(array_diameter_n+1)*lens_diameter/2);
intensity = zeros(size(x,1));
aperture = zeros(size(x,1));

%Generate comparative ideal lens
r = sqrt((x).^2 + (y).^2);

equivalent_aperture = round(abs(r) < lens_diameter*array_diameter_n/2);


%Generate Hex
for i=-(array_diameter_n-1)/2:(array_diameter_n-1)/2
   for j = -(array_diameter_n-abs(i)-1)/2:(array_diameter_n-abs(i)-1)/2
       sub_i = gaussian_lens(x-lens_diameter*j,y-2*(lens_diameter/2)*sin(pi/3)*i);
       intensity = intensity + sub_i;
       aperture = aperture + lens(x-lens_diameter*j,y-2*(lens_diameter/2)*sin(pi/3)*i,lens_diameter,fetch_data(11));
   end
end

%Generate Circle bounded array
%for i=-(array_diameter_n+1)/2:(array_diameter_n+1)/2
%    for j = -(array_diameter_n-abs(i)-1)/2:(array_diameter_n-abs(i)-1)/2
%      if sqrt((lens_diameter*j)^2 + (2*(lens_diameter/2)*sin(pi/3)*i)^2) <= lens_diameter*(array_diameter_n-1)/2
%       [sub_i,sub_a] = gaussian_lens(x-lens_diameter*j,y-2*(lens_diameter/2)*sin(pi/3)*i);
%       intensity = intensity + sub_i;
%       aperture = aperture + sub_a;
%      end
%    end
%end
%intensity = intensity .* (sqrt(x.^2+y.^2)<(array_diameter_n*lens_diameter/2));

field = sqrt(intensity);


%Plot Hex Grid
subplot(1,3,1)
imagesc(x(1,:),y(:,1),intensity);
title('Lens Array')

%Plot sub apertures
subplot(1,3,2)
imagesc(x(1,:),y(:,1), abs(aperture));
title('Sub Apertures')

%Plot equivalent aperture
subplot(1,3,3)
imagesc(x(1,:),y(:,1), equivalent_aperture);
title('Equivalent Aperture')

strehl(field,aperture)
strehl(field,aperture,equivalent_aperture)