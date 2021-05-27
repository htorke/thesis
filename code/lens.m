function [aperture] = lens(x,y,px,py,dx,dy,dz,d,aberration,theta,rho,phi,rm)
  %X
  %Y
  %Diameter
  %Aberration is specified filename
  %Theta - Pitch angle
  %Rho - Off axis magnitude
  %Phi - Off axis rotation
    
  if nargin < 13
     rm = 'none'; 
  end
  if nargin < 12
     phi = 0; 
  end
  if nargin < 11
     rho = 30; 
  end
  if nargin < 10
     theta = 0; 
  end
  

  
  
[x_adj,y_adj] = ellipse_adjust(x,y,px,py,d/2,theta,rho,phi);
r = sqrt((x_adj).^2 + (y_adj).^2);
m = round(abs(r) < d/2);

  if(nargin > 5)
      if aberration == -1
        opd = zeros(size(x));
      else
        opd = ray_trace(x_adj,y_adj,dx,dy,dz,d,rm);
      end
  else
    opd = zeros(size(x));
  end
  


phase = exp(sqrt(-1)*2*pi*opd*sqrt(cos(2*pi*rho/360)));

aperture = phase .* m;
end