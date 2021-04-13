function [xadj,yadj,cx,cy] = ellipse_adjust(x,y,px,py,R,theta,rho,phi)

%dz = Dtan(theta)
%w = Dcos(phi)
%L = D/sin(theta)
%Sx = D sin(phix) sin(theta)/cos(theta)
%Sy = D sin(theta+phiy)/sin(theta)
D = 2*R;
phi_x = rho * cos(2*pi*phi/360);
phi_y = rho * sin(2*pi*phi/360);

%Z offset of successive rows
delta = D*cot(2*pi*theta/360);
%Spatial separation between successive rows
G = sqrt(3)/2*D*(sin(2*pi*theta/360) + (cos(2*pi*theta/360).^2)/sin(2*pi*theta/360));
%Row number
Ny = py/(D*sqrt(3)/2);
Nx = px/(D);

%Row Shift from off axis angle
shift_x = Ny*delta*sin(2*pi*phi_x/360);
shift_y = Ny*(G*sin(2*pi*(theta+phi_y)/360));



%Scale factors
wy = 1;
wx = cos(2*pi*rho/360);
tilt = 2*pi*(phi)/360;


cx =Nx*D*cos(2*pi*phi_x/360)+shift_x;
cy =-Nx*D*sin(2*pi*phi_x/360)+shift_y;

xs = x-cx;
ys = y-cy;
xadj = (xs*cos(tilt) + ys*sin(tilt))/wx;
yadj = (-ys*cos(tilt) + xs*sin(tilt))/wy;

end