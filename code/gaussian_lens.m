function [field,power,x,y] = gaussian_lens(x,y,px,py,R,sigR,dl,dx,dy,dz,theta,rho,phi)
%Inputs:
%x - Coordinate array of X
%y - Coordinate array of Y
%px - Shift of X
%py - Shift of Y
%R - Radius of lens
%sigR - ratio of Gaussian sigma/Radius
%dl - Spatial resolution
%dx - Fine positioning along X axis
%dy - Fine positioning along Y axis
%dz - Fine positioning along Z axis
%theta - Pitch angle of array in degrees
%rho - Off axis angular magnitude
%phi - Off axis angular rotation
if nargin < 11
   theta = 0; 
end

if nargin < 12
    rho = 0;
end

if nargin < 13
   phi = 0; 
end

if nargin < 8
    dx = 0;
end

if nargin < 9
    dy = 0;
end

if nargin < 10
    dz = 0;
end

if nargin < 6
  sigR = 0.447;
end

if nargin < 5
  R = 0.015;
end

if nargin < 7
  dl = 0.0001;
end

if nargin < 2
  [x,y] = meshgrid(-0.03:dl:0.03);
end

if nargin < 3
   px = 0; 
end

if nargin < 4
    py = 0;
end
  

[x_adj,y_adj] = ellipse_adjust(x,y,px,py,R,theta,rho,phi);
r = sqrt((x_adj).^2 + (y_adj).^2);

intensity = gauss(x_adj,y_adj,R,0,0,sigR);
aperture = round(abs(r) < R);

field = sqrt(intensity).*aperture;
power = sum(sum(intensity));