


[x,y] = meshgrid(-30:0.01:30);

r = sqrt(x.^2+y.^2);
aperture = round(r <= 1);

theta = atan2(y,x);

field = exp(-sqrt(-1)*theta);
ff = fftshift(fft2(field.*aperture));

subplot(1,3,1);
imagesc(abs(ff));

subplot(1,3,2);
imagesc(real(ff));

subplot(1,3,3);
imagesc(imag(ff));