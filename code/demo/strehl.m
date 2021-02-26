function [S] = strehl(field, power, aperture_width, dl)
  %Arguments
  %Field - After aperture
  %Total Power
  %Aperture Width - Ideal aperture diameter
  %Dl - Spatial resolution
  
  
  %Calculating unit cell Strehl
  if aperture_width == Inf
      mask = sum(sum(ones(size(field))));
  else
      mask = (pi*aperture_width/2*aperture_width/2/dl/dl);
  end
  
  
  equivalent_intensity = power/mask;
  equivalent_field = sqrt(equivalent_intensity)*mask;

  
%  S = (abs(sum(sum(field.*aperture)))/abs(sum(sum(equivalent_field))))^2;
%  S = (sum(sum(e))/(sqrt(p/(pi*r*r/dl/dl))*(pi*r*r/dl/dl))).^2
  S = (abs(sum(sum(field)))/equivalent_field)^2;
end