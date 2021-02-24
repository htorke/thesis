function [intensity,aperture,x,y] = gaussian_lens(x,y,R,sigR,dl)

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

[intensity,aperture] = gauss(x,y,R,0,0,sigR);