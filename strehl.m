function [S] = strehl(field, aperture, ideal_aperture, x, y, fx, fy)
  %Takes field before entering aperture and aperture itself
  %Optional argument ideal_aperture
  %Optional arguments: x,y,fx,fy for calculating tilt
  
  if nargin < 7
    fx = 0;
    fy = 0;
  end
  
  if nargin < 3
    ideal_aperture = aperture;
  end
  intensity = field.*conj(field);
  
  mask = round(abs(ideal_aperture)>0);
  
  equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
  equivalent_field = sqrt(equivalent_intensity);

  
  S = (abs(sum(sum(field.*aperture)))/abs(sum(sum(equivalent_field))))^2;

end