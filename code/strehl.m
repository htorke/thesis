function [S] = strehl(field, aperture, ideal_aperture)
  %Arguments
  %Field
  %Aperture
  %Ideal Aperture
  %Optional argument ideal_aperture
  
  
  if nargin < 3
    ideal_aperture = aperture;
  end
  intensity = field.*conj(field);
  
  mask = round(abs(ideal_aperture)>0);
  
  equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
  equivalent_field = sqrt(equivalent_intensity);

  
  S = (abs(sum(sum(field.*aperture)))/abs(sum(sum(equivalent_field))))^2;

end