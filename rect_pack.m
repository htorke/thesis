function [intensity,aperture,x,y] = rect_pack(x,y,dl,D,sigR)
%Close Packed Rectangular Cell
% Arguments: 
% x,y - set to -0.3:0.001:0.3 as default
% dl - set to 0.001 as default
% D - set to 0.3 as default
% sigR - set to 0.447 as default
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

lens_diameter = 30e-2;
cell_width = 2*lens_diameter;
cell_height = 2*lens_diameter;


intensity = zeros(size(x));
mask = zeros(size(x));

for u = -2:2
for v = -2:2
[i, m] = gauss(x+u*lens_diameter,y+v*lens_diameter,lens_diameter/2,0,0);
intensity = intensity + i;
mask = mask + m;
end
end


field = sqrt(intensity);

equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
equivalent_field = sqrt(equivalent_intensity);
aperture = mask;