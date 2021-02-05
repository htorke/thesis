function [S] = strehl_i(intensity)
  E = sqrt(intensity);
  
  mask = round(intensity>0);
  
  equivalent_intensity = sum(sum(intensity))*mask/sum(sum(mask));
  equivalent_field = sqrt(equivalent_intensity);
  
  I = abs(E).^2;
  
  S = (abs(sum(sum(E)))/abs(sum(sum(equivalent_field))))^2;

end