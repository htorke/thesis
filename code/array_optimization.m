%Lens array optimization strategies

[S_base,S_ideal,field_base,aperture,p,dl,lens_diameter] = lens_array_oslo(11,5,90);

%Approach 1
[x,y] = meshgrid(linspace(-1,1,509));
parab = sqrt(x.^2 +y.^2);

S = zeros(1,101);
for mag = 0:10
for pist = 0:0.001:1
    shift = exp(sqrt(-1)*2*pi*(((mag-50)/10000)*parab.^2 + pist));
    shift = shift.*aperture;

    field = field_base.*shift;
    meas = strehl(field.*aperture,p,dl,lens_diameter,'tile',19);
    if meas > S(mag + 1)
        S(mag + 1) = meas;
    end
end
end
plot(((0:100)-50)/10000,S)
title('Optimized Strehl')
xlabel('Parabolic coefficient')

f(1:509,1:509) = field_base;
imagesc(fftshift(abs(fft2(f))))

%Approach 2
%fourier = fft2(field_base);
%ef = fourier;
%ef(1,1) = 0;
%error = ifft2(ef);
