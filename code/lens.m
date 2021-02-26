function [aperture] = lens(x,y,d,aberration)
  %X
  %Y
  %Diameter
  %Aberration is specified filename
  
  if(nargin > 3)
      if aberration == -1
        phase = ones(size(x));
      else
        opd = zernike(x,y,d/2,aberration);
        phase = exp(sqrt(-1)*2*pi*opd);
      end
  else
    phase = ones(size(x));
  end
  

  r = sqrt(x.^2 + y.^2);
  aperture = phase .* round(abs(r) < d/2);
end