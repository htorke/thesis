function [ screen ] = phase_screen( r, r0 )
%phase_screen 
%   Produces a phase screen based on modified Von Karman spectrum
%   Calculation is based on Fried parameter r0

    %Phase Structure function is created here
    %PSD_phi = 2*pi^2*k^2*dz*PSD_n [Numerical Simulation (9.48)]
    
    %Index of Refraction spectrum
    %PSD_n = 0.033 Cn^2 exp(-k^2/km^2) (k^2 + k0^2)-11/6
    
    %Phase power spectrum = -1/2 F{D_phase}
    %D_kolmog(r) = 6.88(r/r0)^5/3 [Numerical Simulation (9.44)]

    D_kolmog = 6.88*(r/r0).^(5/3);
    phi = D_kolmog;%ifft2(sqrt(0.5)*sqrt(fft2(D_kolmog)));
    
    %Wave structure function approximation [Numerical Simulation (9.47)]
    %DmvK(r) = 7.75(r0^-5/3)(li^-1/3)r^2[-0.72(k0li)^1/3 / (1 + 2.03r^2/li^2)^1/6]
    
    %Constants
%    k0 = 2*pi/lo;
%    km = 5.92/li;
    
    %Kolmogorov spectrum
    %PSD_phi = 0.49*r0^(-5/3)*K.^(-11/3);
    %Von Karman spectrum
    %PSD_phi = 0.49*r0^(-5/3)*sqrt(K.^2 + k0.^2).^(-11/3);
    %Modified Von Karman spectrum
%    PSD_phi = 0.49*r0^(-5/3)*exp(-(K.^2)/(km.^2)).*sqrt(K.^2 + k0.^2).^(-11/3);
%    phi = ifft(sqrt(PSD_phi));
    
    screen = exp(sqrt(-1)*phi);
    
end

