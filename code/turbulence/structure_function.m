t = -50:49;
x = 1+cos(2*pi*t/25);
plot(t,x)

D = zeros(1,100);
for n = -50:49
   D(n+51) = sum((x - [x(abs(n)+1:100) x(1:abs(n))]).^2)/100;
end

subplot(1,3,1)
plot(t,x,t,D)
title('Cosine and Associated Structure Function')

xf = fft(x);
xp = (abs(xf).^2)/100;

Df = fft(D);

subplot(1,3,2)
plot((-50:49)/100,fftshift(xp))
title("Power Spectrum of Cosine")

subplot(1,3,3)
plot(t,fftshift(real(Df)),t,fftshift(imag(Df)))
title("Fourier Transform of Structure Function")