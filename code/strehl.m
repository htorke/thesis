function [S] = strehl(field, power, dl, aperture_width, shape)
  %Arguments
  %Field - After aperture
  %Total Power
  %Aperture Width - Ideal aperture diameter
  %Dl - Spatial resolution
  
  if nargin < 6
     shape = 'circ';
  end

  
  %Calculating unit cell Strehl
  if aperture_width == Inf
      mask = sum(sum(ones(size(field))));
  else
      if strcmp(shape, 'circ')
          mask = (pi*aperture_width/2*aperture_width/2/dl/dl);
      elseif strcmp(shape, 'hex')
        mask = (sqrt(3)/4 +sqrt(3))*aperture_width*aperture_width/3/dl/dl;
      end
  end
  
  
  equivalent_intensity = power/mask;
  equivalent_field = sqrt(equivalent_intensity)*mask;
  
  S = (abs(sum(sum(field)))/equivalent_field)^2;
end