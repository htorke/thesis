function [S] = strehl(field, power, dl, aperture_width, shape, n_apertures)
  %Arguments
  %Field - After aperture
  %Total Power
  %Aperture Width - Ideal aperture diameter
  %Dl - Spatial resolution
  
  if nargin < 5
     shape = 'circ';
  end
  
  if nargin < 6
     n_apertures = 1; 
  end

  %Calculating unit cell Strehl
  if aperture_width == Inf
      mask = sum(sum(ones(size(field))));
  else
      if strcmp(shape, 'circ')
          mask = (pi*aperture_width/2*aperture_width/2/dl/dl);
      elseif strcmp(shape, 'hex')
        mask = sqrt(3)/2*aperture_width*aperture_width/dl/dl;
      elseif strcmp(shape, 'tile')
          %Unit area of 1 hex cell
          mask = 2*sqrt(3)*aperture_width/2*aperture_width/2/dl/dl;
      end
  end
  
  if power > 0
      equivalent_intensity = power/mask;
  else
      equivalent_intensity = 1;
  end
      
  equivalent_field = sqrt(equivalent_intensity);
  
  %Field/(N*Mask) == Integration of equivalent field over area
  %Mask is area of hex cell so this is multiplying field by total area
  S = (abs(sum(sum(field)))/(n_apertures*mask*equivalent_field))^2;
end