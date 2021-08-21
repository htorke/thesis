%function [ret_opd] = ray_trace(x,y,px,py,pz,D,remove)

nargin = 0;

if nargin < 5
    py = 0e-3;
    px = (-497.732639e-3);;
    pz = (-497.732639e-3);
end

if nargin < 6
%Lens diameter
    D = 25.4e-3;
end

if nargin < 7
   remove = 'tilt'; 
end

if nargin < 2
    [x,y] = meshgrid(D*(-0.75:0.001:0.75));
end

%Lens Description: AC254-500-C

%Front of lens 1
R1 = 87.9e-3;
C1 = 1;
P1 = 0e-3;
%Back of lens 1, front of lens 2
R2 = 115.5e-3;
C2 = -1;
P2 = 3.5e-3;
%Back of lens 2
R3 = 194.5e-3;
C3 = 1;
P3 = 5.5e-3;

%Width of whole lens
width = P3 + R3*(1-cos(asin(D/2/R3)));

lambda = 1.06e-4;

%Refractive Index of Air
N1 = 1;
%NSF-2
N2 = 1.72717;
%NSF-6
N3 = 1.77341;

%Lens 1 width
W1 = 3.5e-3;
%Lens 2 width
W2 = 2e-3;

T1 = R1 - R1*cos(asin((25.4e-3)/2/R1));
T3 = R2 - R2*cos(asin((25.4e-3)/2/R2));
T2 = W1-T1-T3;
T4 = W2;
T5 = R3 - R3*cos(asin((25.4e-3)/2/R3));


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
cy = (rx.*sz-sx.*rz)*-1;
cz = (rx.*sy-sx.*ry);

%Snells law for interface 1
%Mask the angles here because sometimes behavior is odd outside of aperture
sinangle1 = sqrt(cx.^2 + cy.^2 + cz.^2); 
sinangle2 = mask.*sinangle1*N1/N2;

%Tangent vector -> (r x s) x r
tx = (cy.*rz-ry.*cz);
ty = (cx.*rz-rx.*cz)*-1;
tz = (cx.*ry-rx.*cy);
tr = sqrt(tx.^2 + ty.^2 + tz.^2);
%Tangent length, length of perpindicular vector
tlength = R1*tan(asin(sinangle2));

%Lens1 vector - Propagation vector through lens 1 medium
lx = (tlength.*tx./tr - x); 
ly = (tlength.*ty./tr - y);
lz = (P1+C1*R1+tlength.*tz./tr - z);
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
c = x.^2 + y.^2 + z.^2 + 2*(Ct*Rt*Pt -z.*Ct*Rt -z.*Pt) + Pt.^2;

path2 = (-b - Ct*sqrt(b.^2 - 4.*a.*c))./a/2;
 
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
cy = (rx.*sz-sx.*rz)*-1;
cz = (rx.*sy-sx.*ry);

%Snells law for interface 2
%Mask the angles here because sometimes behavior is odd outside of aperture
sinangle1 = sqrt(cx.^2 + cy.^2 + cz.^2); 
sinangle2 = mask.*sinangle1*N2/N3;

%Tangent vector -> (r x s) x r
tx = (cy.*rz-ry.*cz);
ty = (cx.*rz-rx.*cz)*-1;
tz = (cx.*ry-rx.*cy);
tr = sqrt(tx.^2 + ty.^2 + tz.^2);
tlength = R2*tan(asin(sinangle2));

%Lens2 vector - Propagation vector through lens 2 medium
lx = (tlength.*tx./tr - bx);
ly = (tlength.*ty./tr - by);
lz = (P2+C2*R2+tlength.*tz./tr - bz);
lr = sqrt(lx.^2 + ly.^2 + lz.^2);

%AL^2 + BL + C = 0
Ct = C3;
Rt = R3;
Pt = P3;
a = (lx./lr).^2 + (ly./lr).^2 + (lz./lr).^2;
b = 2*(bx.*lx./lr + by.*ly./lr + bz.*lz./lr - (Ct*Rt+Pt)*lz./lr);
c = bx.^2 + by.^2 + bz.^2 + 2*(Ct*Rt*Pt -bz.*Ct*Rt -bz.*Pt) + Pt.^2;

path3 = (-b - Ct*sqrt(b.^2 - 4.*a.*c))./a/2;

 %Previous Boundary point
 bpx = bx;
 bpy = by;
 bpz = bz;
 
 %Boundary point of Lens2 Rear
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
rz = ((C3*P3+R3)-bz)/R3;

%r x s = r*s*sin(theta)
cx = (ry.*sz-sy.*rz);
cy = (rx.*sz-sx.*rz)*-1;
cz = (rx.*sy-sx.*ry);

%Snells law for interface 2
%Mask the angles here because sometimes behavior is odd outside of aperture
sinangle1 = sqrt(cx.^2 + cy.^2 + cz.^2); 
sinangle2 = mask.*sinangle1*N3/N1;

%Tangent vector -> (r x s) x r
tx = (cy.*rz-ry.*cz);
ty = (cx.*rz-rx.*cz)*-1;
tz = (cx.*ry-rx.*cy);
tr = sqrt(tx.^2 + ty.^2 + tz.^2);
tlength = R3*tan(asin(sinangle2));

%Lens3 vector
lx = (tx.*tlength./tr - bx);
ly = (ty.*tlength./tr - by);
lz = (P3+C3*R3+tz.*tlength./tr - bz);
lr = sqrt(lx.^2 + ly.^2 + lz.^2);

path4 = (width - bz)./lz;

%Previous Boundary point
bpx = bx;
bpy = by;
bpz = bz;

%Boundary point of Lens2 Rear
bx = bpx + path4.*lx./lr;
by = bpy + path4.*ly./lr;
bz = bpz + path4.*lz./lr;


r = sqrt(bx.^2 + by.^2);
dr = sqrt((lx./lr).^2+(ly./lr).^2);
intersect = mask.*(r./dr);

opd = mask.*(N1*path1 + N2*path2 + N2*path3 + N1*path4)/lambda;

if contains(remove,'tilt')
    tiltx = x.*mask*sum(sum(opd.*mask.*x));
    tilty = y.*mask*sum(sum(opd.*mask.*y));
   ret_opd = opd - tiltx - tilty;
else
    ret_opd = opd;
end
%focus = targ*intersect(752,752)/intersect(752,752)
%
imagesc(mask.*(ret_opd))