clear;
%Lens Description: AC254-500-C

px = 500e-3;
py = 0e-3;
pz = -497.732639e-3;

%Lens diameter
D = 25.4e-3;

%Front of lens 1
R1 = 87.9e-3;
%Back of lens 1, front of lens 2
R2 = 115.5e-3;
%Back of lens 2
R3 = 194.5e-3;

%Lens 1 width
W1 = 3.5e-3;
%Lens 2 width
W2 = 2e-3;

T1 = R1 - R1*cos(asin((25.4e-3)/2/R1));
T3 = R2 - R2*cos(asin((25.4e-3)/2/R2));
T2 = W1-T1-T3;
T4 = W2;
T5 = R3 - R3*cos(asin((25.4e-3)/2/R3));

%Coordinates in mm
[x,y] = meshgrid(D*(-0.75:0.001:0.75));

r = sqrt(x.^2 + y.^2);
aperture = round(r <= D/2);


%Distance from point to surface 1
z1 = R1 - sqrt(R1^2 - x.^2 -y.^2);
d1 = sqrt((x-px).^2 + (y-py).^2 + (z1-pz).^2);

imagesc(d1);