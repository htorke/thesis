function [field,power,x,y] = hex_pack(r,sigR,dl)
%Close Packed Hex Cell
% Arguments: 
% r - set to 0.015 as default
% sigR - set to 0.447 as default
% dl - set to 0.001 as default

if nargin < 2
  sigR = 0.447;
end

if nargin < 1
  lens_radius = 15e-3;
else
  lens_radius = r;
end

if nargin < 3
  dl = 0.0001;
end

cell_width = 2*lens_radius*2;
cell_height = sqrt(3)*lens_radius*2;

[x,y] = meshgrid((-cell_width/2:dl:cell_width/2),(-cell_height/2:dl:cell_height/2));

field = zeros(size(x));
power = 0;


%+1,0
[e,p] = gaussian_lens(x+lens_radius,y,lens_radius,sigR,dl);
field = field + e;
power = power+p;

%-1,0
[e,p] = gaussian_lens(x-lens_radius,y,lens_radius,sigR,dl);
field = field + e;
power = power+p;

%-1,1
[e,p] = gaussian_lens(x-lens_radius*2,y+sqrt(3)*lens_radius,lens_radius,sigR,dl);
field = field + e;
power = power+p;

%0,1
[e,p] = gaussian_lens(x,y+sqrt(3)*lens_radius,lens_radius,sigR,dl);
field = field + e;
power = power+p;

%1,1
[e,p] = gaussian_lens(x+lens_radius*2,y+sqrt(3)*lens_radius,lens_radius,sigR,dl);
field = field + e;
power = power+p;

%-1,-1
[e,p] = gaussian_lens(x-lens_radius*2,y-sqrt(3)*lens_radius,lens_radius,sigR,dl);
field = field + e;
power = power+p;

%0,-1
[e,p] = gaussian_lens(x,y-sqrt(3)*lens_radius,lens_radius,sigR,dl);
field = field + e;
power = power+p;

%1,-1
[e,p] = gaussian_lens(x+lens_radius*2,y-sqrt(3)*lens_radius,lens_radius,sigR,dl);
field = field + e;
power = power+p;
