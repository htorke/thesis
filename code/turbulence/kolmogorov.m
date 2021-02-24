cn=1;

f = 0:0.1:60;
k = 2*pi*f;

Lo = 1/10;
Li = 1;

flo = 1/Li;
fhi = 1/Lo;

klo = 2*pi*flo;
khi = 2*pi*fhi;


%Base model
kolmog = 0.0330054*(cn^2)*(k).^(-11/3);
kolmog(1:60) = zeros(1,60);
kolmog_s = real(ifft(kolmog));
%Modified k to account for Outer radius
ko = sqrt(k.^2 + (2*pi/Lo)^2);
%Modified k to account for Inner radius
ki = k/(5.92/Lo);
karman = 0.0330054*(cn^2)*(ko).^(-11/3);
karman_s = real(ifft(karman));
modified_karman = karman.*exp(-ki.^2);

r0 = 0.423*k^2*cn^2*dz;


subplot(1,2,1);
plot(f,kolmog);
subplot(1,2,2);
plot(abs(kolmog_s(1:300)))