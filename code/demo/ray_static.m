clear;
%Lens Description: AC254-30-C
lambda = 1.33e-6;
px = 0e-3;
py = 0e-3;
pz = -22.2e-3;

%Lens diameter
D = 25.4e-3;

%Front of lens 1
R1 = 71.1e-3;
C1 = 1;
P1 = 0e-3;
%Back of lens 1, front of lens 2
R2 = 15.2e-3;
C2 = 1;
P2 = 1.8e-3;
%Back of lens 2
R3 = 21.1e-3;
C3 = 1;
P3 = 14.8e-3;

%Image EQ
efl = 30.4e-3;

%Width of whole lens
width = 14.8e-3 - R3*(1-cos(asin(D/2/R3)));

%Refractive Index of Air
N1 = 1;
%NSF-2
N2 = 1.77341;
%NSF-6
N3 = 1.65404;

%Lens 1 width
W1 = 1.8e-3;
%Lens 2 width
W2 = 13.0e-3;


%Coordinates in mm
[x,y] = meshgrid(-0.5*D:0.0001:0.5*D);

r = sqrt(x.^2 + y.^2);
aperture = round(r <= D/2);
mask = round((x.^2+y.^2) < (D/2).^2);

%Distance from point to surface 1
z = R1 - sqrt(R1^2 - x.^2 -y.^2);
d1 = sqrt((x-px).^2 + (y-py).^2 + (z-pz).^2);
path1 = d1;
%Compute cross product of radial ray to source ray
%Radius segment vector
rx = (0-x)/R1;
ry = (0-y)/R1;
rz = (C1*R1-z)/R1;

%Source segment vector
sr = sqrt((x-px).^2 + (y-py).^2 + (z-pz).^2);
sx = (x - px)./sr;
sy = (y - py)./sr;
sz = (z - pz)./sr;

%r x s = r*s*sin(theta)
cx = (ry.*sz-sy.*rz);
cy = (rx.*sz-sx.*rz);
cz = (rx.*sy-sx.*ry);

%Snells law for interface 1
%Mask the angles here because sometimes behavior is odd outside of aperture
sinangle1 = sqrt(cx.^2 + cy.^2 + cz.^2); 
sinangle2 = sinangle1*N1/N2;

%Tangent vector -> r x (r x s)
tx = (ry.*cz-cy.*rz);
ty = (rx.*cz-cx.*rz);
tz = (rx.*cy-cx.*ry);
tr = sqrt(tx.^2 + ty.^2 + tz.^2);
%Tangent length, length of perpindicular vector
tlength = C1*R1*tan(asin(sinangle2));

%Lens1 vector - Propagation vector through lens 1 medium
lx = C1*(tlength.*tx./tr - x);
ly = C1*(tlength.*ty./tr - y);
lz = C1*(P1+C1*R1+tlength.*tz./tr - z);
lr = sqrt(lx.^2 + ly.^2 + lz.^2);

%Lens1 to Lens2 is intersection of Lens1 vector and Lens2 surface
%Assuming lens is centered in x-y, offset in Z
%A = Vx^2 + Vy^2 + Vz^2)
%B = 2(PxVx + PyVy + PzVz - VzCR - VzS)
%C = (Px^2 + Py^2 + Pz^2 + -2PzCR -2PzS +2CRS + S^2)

%Vx = Normalized vector x component
%Vy = Normalized vector y component
%Vz = Normalized vector z component
%Px = Ray origin x component
%Py = Ray origin y component
%Pz = Ray origin z component

%Rs = Radius + ZOffset
%R = Radius
% 
%AL^2 + BL + C = 0

Ct = C2;
Rt = R2;
Pt = P2;
a = (lx./lr).^2 + (ly./lr).^2 + (lz./lr).^2;
b = 2*(x.*lx./lr + y.*ly./lr + z.*lz./lr - (Ct*Rt+Pt)*lz./lr);
c = x.^2 + y.^2 + z.^2 + Pt.^2 + 2*(Ct*Rt*Pt -z.*Ct*Rt -z.*Pt);

path2 = ((-b - Ct*sqrt(b.^2 - 4.*a.*c))./a/2);
 
%Previous Boundary point
 bpx = x;
 bpy = y;
 bpz = z;
 
%Boundary point of Lens2
bx = x + path2.*lx./lr;
by = y + path2.*ly./lr;
bz = z + path2.*lz./lr;

%Radius segment vector
rx = (0-bx)/R2;
ry = (0-by)/R2;
rz = ((C2*R2+P2)-bz)/R2;
%Source segment vector
sr = sqrt((bx - bpx).^2 + (by - bpy).^2 + (bz - bpz).^2);
sx = (bx - bpx)./sr;
sy = (by - bpy)./sr;
sz = (bz - bpz)./sr;

%r x s = r*s*sin(theta)
cx = (ry.*sz-sy.*rz);
cy = (rx.*sz-sx.*rz);
cz = (rx.*sy-sx.*ry);

%Snells law for interface 2
%Mask the angles here because sometimes behavior is odd outside of aperture
sinangle1 = sqrt(cx.^2 + cy.^2 + cz.^2); 
sinangle2 = sinangle1*N2/N3;

%Tangent vector -> r x (r x s)
tx = (ry.*cz-cy.*rz);
ty = (rx.*cz-cx.*rz);
tz = (rx.*cy-cx.*ry);
tr = sqrt(tx.^2 + ty.^2 + tz.^2);
tlength = C2*R2*tan(asin(sinangle2));

%Lens2 vector - Propagation vector through lens 2 medium
lx = C2*(tlength.*tx./tr - bx);
ly = C2*(tlength.*ty./tr - by);
lz = C2*(P2+C2*R2+tlength.*tz./tr - bz);
lr = sqrt(lx.^2 + ly.^2 + lz.^2);

%AL^2 + BL + C = 0
Ct = C3;
Rt = R3;
Pt = P3;
a = (lx./lr).^2 + (ly./lr).^2 + (lz./lr).^2;
b = 2*(bx.*lx./lr + by.*ly./lr + bz.*lz./lr - (Ct*Rt+Pt)*lz./lr);
c = bx.^2 + by.^2 + bz.^2 + 2*(Ct*Rt*Pt -bz.*Ct*Rt -bz.*Pt) + Pt.^2;

path3 = mask.*((-b - Ct*sqrt(b.^2 - 4.*a.*c))./a/2);

% Previous Boundary point
bpx = bx;
bpy = by;
bpz = bz;
 
% Boundary point of Lens2 Rear
bx = bpx + path3.*lx./lr;
by = bpy + path3.*ly./lr;
bz = bpz + path3.*lz./lr;


 
%Ray vector
sr = sqrt((bx - bpx).^2 + (by - bpy).^2 + (bz - bpz).^2);
sx = (bx - bpx)./sr;
sy = (by - bpy)./sr;
sz = (bz - bpz)./sr;

%Radial vector
rx = (0-bx)/R3;
ry = (0-by)/R3;
rz = ((C3*R3+P3)-bz)/R3;

%r x s = r*s*sin(theta)
cx = (ry.*sz-sy.*rz);
cy = (rx.*sz-sx.*rz);
cz = (rx.*sy-sx.*ry);

%Snells law for interface 2
%Mask the angles here because sometimes behavior is odd outside of aperture
sinangle1 = sqrt(cx.^2 + cy.^2 + cz.^2); 
sinangle2 = sinangle1*N3/N1;

%Tangent vector -> r x (r x s)
tx = (ry.*cz-cy.*rz);
ty = (rx.*cz-cx.*rz);
tz = (rx.*cy-cx.*ry);
tr = sqrt(tx.^2 + ty.^2 + tz.^2);
tlength = C3*R3*tan(asin(sinangle2));

%Lens3 vector
lx = C3*(tx.*tlength./tr - bx);
ly = C3*(ty.*tlength./tr - by);
lz = C3*(P3+C3*R3+tz.*tlength./tr - bz);
lr = sqrt(lx.^2 + ly.^2 + lz.^2);

path4 = (width - bz)./lz;

opd = mask.*(N1*path1 + N2*path2 + N3*path3 )/lambda;

 imagesc(imag(mask.*opd))