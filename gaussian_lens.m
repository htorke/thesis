function [intensity,aperture,x,y] = gaussian_lens(x,y,dl,R,sigR)

if nargin < 5
  sigR = 0.447;
end

if nargin < 4
  R = 0.15;
end

if nargin < 3
  dl = 0.001;
end

if nargin < 2
  [x,y] = meshgrid(-0.3:dl:0.3);
end

[intensity,aperture] = gauss(x,y,R,0,0,sigR);