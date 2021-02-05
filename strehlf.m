function [S] = strehlf(field, aperture)
  
  intensity = field.*conj(field);
  
  mask = round(abs(aperture)>0);
  
  equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
  equivalent_field = sqrt(equivalent_intensity);

  f_field = fft2(field.*aperture);
  f_equiv = fft2(equivalent_field);
  
  S = (abs(f_field(1))/abs(f_equiv(1)))^2;

end