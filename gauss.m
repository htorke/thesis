function [intensity] = gauss(X,Y,radius,center_x,center_y,wr_ratio)

%Optimum Strehl Ratio = 0.815

if nargin < 6
    %Default ratio 0.89 is optimal fill 
    wr = 0.89;
else
    wr = wr_ratio;
end
%Ideal maximum Strehl Ratio occurs at width 0.89 of radius
w0 = wr*radius;
sigma = w0/2;


r = sqrt((X-center_x).^2 + (Y-center_y).^2);
%Lens aperture window function
mask = abs(r)<radius;

%Calculates normalized intensity distribution as a Gaussian distribution
%field = Eo*w0/wz*exp(-r.^2/wz^2)*exp(-sqrt(-1)*(kz + k*r.^2/2Rz-psiz));
z = 1;%meter(focal length)
%field = Eo*w0/wz*exp(-r.^2/wz^2)*exp(-sqrt(-1)*(kz + k*r.^2/2Rz-psiz))
intensity = mask.*exp(-0.5*(r/sigma).^2);
%sum(sum(intensity))/sum(sum(ceil(intensity)))

%Show generated intensity(Debug)
%imagesc(X(1,:),Y(:,1),intensity);
end
