function [intensity,aperture,x,y] = hex_pack(x,y,dl,D,sigR)
%Close Packed Hex Cell
% Arguments: 
% x,y - set to -0.3:0.001:0.3 as default
% dl - set to 0.001 as default
% D - set to 0.3
% sigR - set to 0.447 as default
%
if nargin < 5
  sigR = 0.447;
end

if nargin < 4
  lens_diameter = 30e-2;
else
  lens_diameter = D;
end

if nargin < 3
  dl = 0.001;
  [x,y] = meshgrid(-0.3:dl:0.3);
end

cell_width = 2*lens_diameter;
cell_height = sqrt(3)*lens_diameter;

[x,y] = meshgrid((-cell_width/2:dl:cell_width/2),(-cell_height/2:dl:cell_height/2));

intensity = zeros(size(x));
mask = zeros(size(x));


%+2,0
[i, m] = gauss(x+3*lens_diameter/2,y,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%-2,0
[i, m] = gauss(x-3*lens_diameter/2,y,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%+1,0
[i, m] = gauss(x+lens_diameter/2,y,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%-1,0
[i, m] = gauss(x-lens_diameter/2,y,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%-1,1
[i, m] = gauss(x-lens_diameter,y+sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%0,1
[i, m] = gauss(x,y+sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%1,1
[i, m] = gauss(x+lens_diameter,y+sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%-1,-1
[i, m] = gauss(x-lens_diameter,y-sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%0,-1
[i, m] = gauss(x,y-sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

%1,-1
[i, m] = gauss(x+lens_diameter,y-sqrt(3)*lens_diameter/2,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;

field = sqrt(intensity);

equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
equivalent_field = sqrt(equivalent_intensity);
aperture = mask;