clear;
n_points = 201;
theta = 5;
dl = 5e-4;
lambda = 1.03e-6;

[aberration,dx,dy,dz,efl,lens_diameter] = fetch_data(1);
[x,y] = meshgrid(-lens_diameter:dl:lens_diameter);



%Ideal aperture to compare to
dxy = 2*efl*tan(2*pi*theta/360);
dx = -dxy*sqrt(2)/2;
dy = -dxy*sqrt(2)/2;
r = sqrt((x).^2 + (y).^2 + (2e8*efl).^2);
ap = round(r < (lens_diameter/2));
field = (r/lambda);

res = zeros(1,n_points);

w = waitbar(0,'Sweeping distance offset');
for run_index = 1:n_points
    waitbar(run_index/n_points,w,'Sweeping distance offset');
    [aberration,dx,dy,dz,efl,lens_diameter] = fetch_data(run_index);
    opd = zernike(x*sqrt(3)/2,y,lens_diameter/2,aberration,'none');
    
    
    
    test = mod(opd,1);
    ref  = mod(field,1);
    
    corr = test.*ref;
    tot = ref.*ref.*round(test ~= 0);
    
    res(run_index) = sum(sum(corr))/sum(sum(tot));
end
close(w);

%plot((-100:100)/10,res);
%title('R Sweep, 5 Degree Steering')
%ylabel('Divergence from Ideal')
%xlabel('Delta R')