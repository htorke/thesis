function [S, S_Ideal, field, aperture, p, dl, lens_diameter] = lens_array_oslo(run_index, n, theta, rho, phi, shape)

if nargin < 1
   run_index = 0; 
end


if nargin < 2
    n = 5;
end

if nargin < 3
    theta = 45;  
end

if nargin < 5
   rho = 0; 
   phi = 0;  
end

if nargin < 6
    shape = 'tile';
end


%Defined Parameters
array_diameter_n = n;
%Spatial Resolution
dl = 5e-4;
%illumination = 'uni';
illumination = 'gaus';

n = 0;
w = waitbar(n,'Evaluating array');



%Get OSLO data
[aberration,dx,dy,dz,efl,lens_diameter] = fetch_data(run_index);
dx
dy
dz
efl
if aberration ~= -1
   rho = 360*sqrt(atan2(dy,efl).^2 + atan2(dx,efl).^2)/2/pi
   phi = 360*atan2(atan2(dy,efl),atan2(dx,efl))/2/pi
end
if ~contains(illumination,'uni')
   aberration = -1; 
end

%Derived Parameters
array_n = 0.75*array_diameter_n^2 + 0.25;
equivalent_circle =array_diameter_n*lens_diameter;



[x,y] = meshgrid(-(array_diameter_n+5)*lens_diameter/2:dl:(array_diameter_n+5)*lens_diameter/2);
field = zeros(size(x,1));
aperture = zeros(size(x,1));
power = 0;

%Calculate Ideal Strehl
fill_factor = array_n*lens_diameter*abs(cos(rho))*lens_diameter/(lens_diameter*array_diameter_n)/(lens_diameter*array_diameter_n);
[e,p] = gaussian_lens(x,y,0,0,lens_diameter/2,0.447,dl,dx,dy,dz,90,0,0,illumination);

S_gauss = strehl(e,p,dl,lens_diameter,'circ');
S_Ideal = fill_factor * S_gauss;


%%%%%
ap = lens_oslo(x,y,lens_diameter*j,2*(lens_diameter/2)*sin(pi/3)*i,lens_diameter,aberration,theta,rho,phi,'tilt');
aperture = aperture.*round(abs(ap) == 0) + ap;
        
[sub_f,sub_p] = gaussian_lens(x,y,lens_diameter*j,2*(lens_diameter/2)*sin(pi/3)*i,lens_diameter/2,0.447,dl,dx,dy,dz,theta,rho,phi,illumination);
field = field.*round(abs(ap) == 0) + sub_f;
power = power + sub_p;

%%%%%

%Generate Hex
for i=(array_diameter_n-1)/2:-1:-(array_diameter_n-1)/2
   for j = -(array_diameter_n-abs(i)-1)/2:(array_diameter_n-abs(i)-1)/2

%        ap = lens_oslo(x,y,lens_diameter*j,2*(lens_diameter/2)*sin(pi/3)*i,lens_diameter,aberration,theta,rho,phi,'tilt');
%        aperture = aperture.*round(abs(ap) == 0) + ap;
%        
%        [sub_f,sub_p] = gaussian_lens(x,y,lens_diameter*j,2*(lens_diameter/2)*sin(pi/3)*i,lens_diameter/2,0.447,dl,dx,dy,dz,theta,rho,phi,illumination);
%        field = field.*round(abs(ap) == 0) + sub_f;
%        power = power + sub_p;
       
       n = n + 1;
       waitbar(n/array_n,w,'Evaluating array');
   end
end

close(w);

%Plot Hex Grid
%subplot(1,2,1)
imagesc(x(1,:),y(:,1),real(aperture.*field));
%imagesc(imag(aperture))
view(0,270);
title('Illumination Array')
if strcmp(shape,'circ')
array_diameter = equivalent_circle;
S = strehl(field.*aperture,p*n,dl,array_diameter,'circ');
elseif strcmp(shape,'hex')
%For hex, give aperture size in terms of height of array rather than
%diameter
S = strehl(field.*aperture,p*n,dl,lens_diameter*(1+sqrt(3)*(array_diameter_n+1)/4),'hex');
elseif strcmp(shape,'tile')
%Pass 
S = strehl(field.*aperture,p,dl,lens_diameter,'tile',n);

end