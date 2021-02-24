function [Z] = zernike_poly(x, y, n, m, radius)

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

for k=0:floor((n-m)/2)
  if mod(n-m,2) == 0
    Rmn = (rho.^(n-2*k))*(factorial(n-k)*(-1)^k)/(factorial(k)*factorial(-k + (n+m)/2)*factorial(-k + (n-m)/2));
  else
    Rmn = zeros(size(rho));
  end

  R = R + Rmn.*(abs(r) <= radius);
end

Z = R.*ang_comp;
end