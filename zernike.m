function [Z] = zernike(x, y, n, m, radius)

r = sqrt((x.^2)+(y.^2));
rho = (r/radius).*(abs(r) <= radius);

theta = atan2(y,x);

if (m<0) %Case Odd
  m = -m;
  ang_comp = sin(m*theta);
else%Case Even
  ang_comp = cos(m*theta);
end

R = zeros(size(x));
if n==0
  R = ones(size(rho));
elseif n == 1
  if m == 1
    R = rho;
  end
elseif n==2
  if m == 0
    R = 2*rho.^2 - 1;
  elseif m == 2
    R = rho.^2;
  end
elseif n==3
  if m == 1
    R = 3*rho.^3 - 2*rho;
  elseif m == 3
    R = rho.^3;
  end
elseif n==4
  if m == 0
    R = 6*rho.^4 - 6*rho.^2 + 1;
  elseif m == 2
    R = 4*rho.^4 - 3*rho.^2;
  elseif m == 4
    R = rho.^4;
  end
elseif n==5
  if m == 1
    R = 10*rho.^5 - 12*rho.^3 + 3*rho;
  elseif m == 3
    R = 5*rho.^5 - 4*rho.^3;
  elseif m == 5
    R = rho.^5;
  end
elseif n==6
  if m==0
    R = 20*rho.^6 - 30*rho.^4 + 12*rho.^2 - 1;
  elseif m==2
    R = 15*rho.^6 - 20*rho.^4 + 6*rho.^2;
  elseif m==4
    R = 6*rho.^6 - 5*rho.^4;
  elseif m==6
    R = rho.^6;
  end
end
R = R.*(abs(r) <= radius);
for k=0:floor((n-m)/2)
  if mod(n-m,2) == 0
    Rmn = (rho.^(n-2*k))*(factorial(n-k)*(-1)^k)/(factorial(k)*factorial(-k + (n+m)/2)*factorial(-k + (n-m)/2));
  else
    Rmn = zeros(size(rho));
  end
%  R1 = (Rmn == 1);
%  Rmn =((1-R1).*Rmn + R1);
  R = R + Rmn;
end

Z = R.*ang_comp;
end