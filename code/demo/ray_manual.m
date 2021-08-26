% Ray trace manual
clear;

%Refractive Index of Air
N1 = 1;
%N-BAF10
N2 = 1.64714;
%NSF-6
N3 = 1.76307;

%Lens Radii
R1 = 21.1;
R2 = 15.2;
R3 = 71.1;

%Lens Positions
P1 = 0;
P2 = 13.0;
P3 = 14.8;
P4 = 14.8;

focal_length = 30.4;

theta = -pi/2:pi/500:pi/2;
plot(R1*cos(pi +theta) +R1 + P1, R1*sin(pi + theta))
hold on;
plot(R2*cos(theta) -R2 + P2, R2*sin(theta))
plot(R3*cos(theta) -R3 + P3, R3*sin(theta))

%Starting point
sourcex = 0;
sourcez = -60.8;

for k = 0:10
%First lens boundary
surf1x = k*2.53/2;
%x^2 + (z-R1)^2 = R1^2
%z^2 +R1^2 -2z*R1 + x^2 = R1^2
%z^2 -2*r1*z + x^2 = 0
surf1z = ((2*R1) - sqrt(2*2*R1*R1 - 4*surf1x*surf1x))/2;

ray1x = surf1x - sourcex;
ray1z = surf1z - sourcez;
ray1 = [ray1x/sqrt(ray1x^2 + ray1z^2), ray1z/sqrt(ray1x^2 + ray1z^2)];

%Calculate radius of lens to get angle for snell calculation
rad1x = surf1x;
rad1z = -R1 + surf1z;
tan1x = -rad1z;
tan1z = rad1x;

%Find angle between the two using dot product -> cosine
mray1 = sqrt(ray1x^2 + ray1z^2);
mrad1 = sqrt(rad1x^2 + rad1z^2);
dot1 = abs((ray1x * rad1x) + (ray1z * rad1z))/(mrad1*mray1);
angle1 = 360*acos(dot1)/2/pi;

%Use snells law to find angle across boundary
angle1f = 360*asin(sqrt(1 - dot1^2) * N1/N2)/2/pi;
%Radius :: adjacent Tangent :: opposite tan = tangent/radius
%tan1len is length of tangent
tan1len = sqrt(rad1x^2 + rad1z^2) * tan(2*pi*angle1f/360);

%Add tangent to radius source point
targ2x = 0  + tan1len*tan1x/sqrt(tan1x^2 + tan1z^2);
targ2z = R1 + tan1len*tan1z/sqrt(tan1x^2 + tan1z^2);

%Ray2 is surface of lens1 to target
ray2x = targ2x - surf1x;
ray2z = targ2z - surf1z;
ray2 = [ray2x/sqrt(ray2x^2 + ray2z^2), ray2z/sqrt(ray2x^2 + ray2z^2)];

%Lens2 boundary => x^2 + (z + R2 - P2)^2 = R2^2
%Ray2 => surf1x + L*ray2x , surf1z + L*ray2z

%<surf1x + L*ray2x, surf1z + l*ray2z>
%z = surf1z + L*ray2z
%L = (z-surf1z)/ray2z
%x = surf1x + L*ray2x
%x = surf1x + (z - surf1z)*ray2x/ray2z

%(surf1x + (z - surf1z)*ray2x/ray2z)^2 + (z + R2 - P2)^2 = R2^2

%z^2 + 2*(R2-P2)*z + (P2^2 - 2*R2*P2) +
%surf1x^2 + 2*surf1x*(z - surf1z)*ray2x/ray2z + (z-surf1z)^2 *(ray2x/ray2z)^2 = 0

%(z-surf1z)^2 *(ray2x/ray2z)^2 = z^2 -2*surf1z*z + surf1z^2

%Find z intercept of lens2
A = 1 + (ray2x/ray2z)^2;
B = (2*(R2-P2)) + 2*surf1x*ray2x/ray2z -2*surf1z*(ray2x/ray2z)^2;
C = P2^2 - 2*R2*P2 + surf1x^2 -2*surf1x*surf1z*ray2x/ray2z + surf1z*surf1z*(ray2x/ray2z)^2;

surf2z = (-B + sqrt(B^2 - 4*A*C))/2/A;
%x^2 + (z - P2 + R2)^2 = R2^2
%x^2 = R2^2 - z^2 +2*z*(P2-R2) -(P2-R2)^2 
surf2x = sqrt(R2^2 - surf2z^2 - (P2-R2)^2 + 2*surf2z*(P2-R2));

%Calculate radius of lens to get angle for snell calculation
rad2x = surf2x;
rad2z = surf2z - (-R2 + P2);
tan2x = -rad2z;
tan2z = rad2x;

%Find angle between the two using dot product -> cosine
mray2 = sqrt(ray2x^2 + ray2z^2);
mrad2 = sqrt(rad2x^2 + rad2z^2);
dot2 = abs((ray2x * rad2x) + (ray2z * rad2z))/(mrad2*mray2);
angle2 = 360*acos(dot2)/2/pi;

%Use snells law to find angle across boundary
angle2f = 360*asin(sqrt(1 - dot2^2) * N2/N3)/2/pi;
%Radius :: adjacent Tangent :: opposite tan = tangent/radius
%tan1len is length of tangent
tan2len = sqrt(rad2x^2 + rad2z^2) * tan(2*pi*angle2f/360);

%Add tangent to radius source point
targ3x = 0  - tan2len*tan2x/sqrt(tan2x^2 + tan2z^2);
targ3z = -R2+P2 - tan2len*tan2z/sqrt(tan2x^2 + tan2z^2);

%Ray3 is surface of lens2 to target
ray3x = targ3x - surf2x;
ray3z = targ3z - surf2z;
ray3 = [-ray3x/sqrt(ray3x^2 + ray3z^2), -ray3z/sqrt(ray3x^2 + ray3z^2)];

%Find z intercept of lens2 back
A = 1 + (ray3x/ray3z)^2;
B = (2*(R3-P3)) + 2*surf2x*ray3x/ray3z -2*surf2z*(ray3x/ray3z)^2;
C = P3^2 - 2*R3*P3 + surf2x^2 -2*surf2x*surf2z*ray3x/ray3z + surf2z*surf2z*(ray3x/ray3z)^2;

surf3z = (-B + sqrt(B^2 - 4*A*C))/2/A;
%x^2 + (z - P2 + R2)^2 = R2^2
%x^2 = R2^2 - z^2 +2*z*(P2-R2) -(P2-R2)^2 
surf3x = sqrt(R3^2 - surf3z^2 - (P3-R3)^2 + 2*surf3z*(P3-R3));

%Calculate radius of lens to get angle for snell calculation
rad3x = surf3x;
rad3z = surf3z - (-R3 + P3);
tan3x = -rad3z;
tan3z = rad3x;

%Find angle between the two using dot product -> cosine
mray3 = sqrt(ray3x^2 + ray3z^2);
mrad3 = sqrt(rad3x^2 + rad3z^2);
dot3 = abs((ray3x * rad3x) + (ray3z * rad3z))/(mrad3*mray3);
angle3 = 360*acos(dot3)/2/pi;

%Use snells law to find angle across boundary
angle3f = 360*asin(sqrt(1 - dot3^2) * N3/N1)/2/pi;
%Radius :: adjacent Tangent :: opposite tan = tangent/radius
%tan1len is length of tangent
tan3len = sqrt(rad3x^2 + rad3z^2) * tan(2*pi*angle3f/360);

%Add tangent to radius source point
targ4x = 0  - tan3len*tan3x/sqrt(tan3x^2 + tan3z^2);
targ4z = -R3+P3 - tan3len*tan3z/sqrt(tan3x^2 + tan3z^2);

%Ray4 is surface of lens3 to target
ray4x = targ4x - surf3x;
ray4z = targ4z - surf3z;
ray4 = [-ray4x/sqrt(ray4x^2 + ray4z^2), -ray4z/sqrt(ray4x^2 + ray4z^2)];

surf4z = P4;
surf4x = surf3x + (surf4z-surf3z)*ray4x/ray4z;

targz = 190.8;
targx = surf4x + (targz-surf4z)*ray4x/ray4z;

plot(linspace(sourcez, surf1z,50),linspace(sourcex, surf1x,50))
plot(linspace(surf1z, surf2z,50),linspace(surf1x, surf2x,50))
plot(linspace(surf2z, surf3z,50),linspace(surf2x, surf3x,50))
plot(linspace(surf3z, surf4z,50),linspace(surf3x, surf4x,50))

plot(linspace(surf4z, targz,50),linspace(surf4x, targx,50))

path1 = sqrt((surf1x-sourcex)^2+(surf1z-sourcez)^2);
path2 = sqrt((surf2x-surf1x)^2+(surf2z-surf1z)^2);
path3 = sqrt((surf3x-surf2x)^2+(surf3z-surf2z)^2);
path4 = sqrt((surf4x-surf3x)^2+(surf4z-surf3z)^2);
opd(k+1) = path1*N1 + path2*N2 + path3*N3 + path4*N1;

dist(k+1) = sqrt((0-surf4x)^2 + (targz - surf4z)^2);
end

xlim([-65 75])
ylim([-12.7 12.7])
hold off;

error = (opd-opd(1) - dist + dist(1));
%plot(error)

