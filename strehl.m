function [S] = strehl(field, aperture)
  
  intensity = field.*conj(field);
  
  mask = round(abs(aperture)>0);
  
  equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
  equivalent_field = sqrt(equivalent_intensity);

  
  S = (abs(sum(sum(field.*aperture)))/abs(sum(sum(equivalent_field))))^2;

end