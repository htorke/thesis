function [S] = strehl(field, power,x, y, aperture_width, x_angle, y_angle, lambda)
  %Arguments
  %Field - After aperture
  %Total Power
  %Aperture Width - Ideal aperture diameter
  %Dl - Spatial resolution
  
  if nargin < 8
     x_angle = 0;
     y_angle = 0;
     lambda = 1;
  end
  dl = y(2)-y(1);
  fx = sin(2*pi*x_angle/360)/lambda;
  fy = sin(2*pi*y_angle/360)/lambda;

  angle = exp(-sqrt(-1)*2*pi*(fx*x + fy*y));
  
  %Calculating unit cell Strehl
  if aperture_width == Inf
      mask = sum(sum(ones(size(field))));
  else
      mask = (pi*aperture_width/2*aperture_width/2/dl/dl);
  end
  
  
  equivalent_intensity = power/mask;
  equivalent_field = sqrt(equivalent_intensity)*mask;

  
  S = (abs(sum(sum(field.*angle)))/equivalent_field)^2;
end