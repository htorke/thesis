function [aperture] = lens(x,y,d,aberration)

  %Aberration is specified
  if(nargin > 3)
    opd = zernike(x,y,d/2,aberration);
    phase = exp(sqrt(-1)*2*pi*opd);
  else
    phase = ones(size(x));
  end

  r = sqrt(x.^2 + y.^2);
  aperture = phase .* round(abs(r) < d/2);
end