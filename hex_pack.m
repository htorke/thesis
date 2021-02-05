clear
%Close Packed Hex Cell
dl = 1e-4;
lens_diameter = 30e-2;

cell_width = 2*lens_diameter;
cell_height = sqrt(3)*lens_diameter;

[x,y] = meshgrid((-cell_width/2:dl:cell_width/2),(-cell_height/2:dl:cell_height/2));

intensity = zeros(size(x));
mask = zeros(size(x));


%+1,0
[i, m] = gauss(x+lens_diameter/2,y,lens_diameter/2,0,0);
intensity = intensity + i.*m;
mask = mask + m;

%-1,0
[i, m] = gauss(x-lens_diameter/2,y,lens_diameter/2,0,0);
intensity = intensity + i.*m;
mask = mask + m;

%-1,1
[i, m] = gauss(x-lens_diameter,y+sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i.*m;
mask = mask + m;

%0,1
[i, m] = gauss(x,y+sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i.*m;
mask = mask + m;

%1,1
[i, m] = gauss(x+lens_diameter,y+sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i.*m;
mask = mask + m;

%-1,-1
[i, m] = gauss(x-lens_diameter,y-sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i.*m;
mask = mask + m;

%0,-1
[i, m] = gauss(x,y-sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i.*m;
mask = mask + m;

%1,-1
[i, m] = gauss(x+lens_diameter,y-sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i.*m;
mask = mask + m;

field = sqrt(intensity);

equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
equivalent_field = sqrt(equivalent_intensity);
imagesc(field);
strehl(equivalent_field,field)