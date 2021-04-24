function [aperture] = lens(x,y,px,py,d,aberration,theta,rho,phi,rm)
  %X
  %Y
  %Diameter
  %Aberration is specified filename
  %Theta - Pitch angle
  %Rho - Off axis magnitude
  %Phi - Off axis rotation
  
  if nargin < 7
     theta = 0; 
  end
  
  if nargin < 8
     rho = 30; 
  end
  
  if nargin < 9
     phi = 0; 
  end
  
  if nargin < 10
     rm = 'none'; 
  end
  
[x_adj,y_adj] = ellipse_adjust(x,y,px,py,d/2,theta,rho,phi);
r = sqrt((x_adj).^2 + (y_adj).^2);
m = round(abs(r) < d/2);

  if(nargin > 5)
      if aberration == -1
        opd = zeros(size(x));
      else
        opd = zernike(x_adj,y_adj,d/2,aberration,rm);
      end
  else
    opd = zeros(size(x));
  end


phase = exp(sqrt(-1)*2*pi*opd);

aperture = phase .* m;
end