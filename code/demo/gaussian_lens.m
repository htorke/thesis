function [field,power,x,y] = gaussian_lens(x,y,R,sigR,dl,dx,dy,dz)

if nargin < 6
    dx = 0;
end

if nargin < 7
    dy = 0;
end

if nargin < 8
    dz = 0;
end

if nargin < 4
  sigR = 0.447;
end

if nargin < 3
  R = 0.015;
end

if nargin < 5
  dl = 0.0001;
end

if nargin < 2
  [x,y] = meshgrid(-0.03:dl:0.03);
end

intensity = gauss(x + dx,y + dy,R,0,0,sigR);
aperture = abs(sqrt((x).^2 + (y).^2)) < R;

field = sqrt(intensity).*aperture;
power = sum(sum(intensity));