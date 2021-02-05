function [intensity,aperture,x,y] = gaussian_lens(sigR,x,y,dl)

if nargin < 1
  sigR = 0.447;
end

if nargin < 4
  dl = 0.001;
  [x,y] = meshgrid(-0.3:dl:0.3);
end

[intensity,aperture] = gauss(x,y,0.15,0,0,sigR);