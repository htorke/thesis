clear;
AFOC

%Fried parameter 10cm at 500 nm 25cm at 1.05um
r0_visible = 5e-2:15e-2/99:20e-2;

%Wavelength = 1.05 um
%Zenith angle = 51 degrees

zenith_angle =cos(51 *2*pi/360);
wavelength_ratio = 1050/500;

%Wavelength 6/5
%cos(z) ^3/5
w_correction = wavelength_ratio^(6/5);
z_correction = zenith_angle^(3/5);

r0 = r0_visible*w_correction*z_correction;

turbulence = phase_screen(r,r0(1));

imagesc(abs(turbulence));