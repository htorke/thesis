%function [ret_opd] = ray_trace(x,y,px,py,pz,D,lens_data,remove)
clear;
nargin = 0;

if nargin < 8
   remove = 'tilt'; 
end

if nargin < 7
   lens_data = 'AC-254-300C-1060n.lens'; 
end

if nargin < 6
%Lens diameter
    D = 25.4e-3;
end

if nargin < 5
    py = 0e-3;
    px = 0e-3;
    pz = -22.2e-3;
end

if nargin < 2
    [x,y] = meshgrid(-0.5*D:0.0001:0.5*D);
end

%Initialize eventual return array
opd = zeros(size(x));

%Parse lens data
fd = fopen(sprintf('./lenses/%s',lens_data),'r');
line = 0;
N = [];
R = [];
P = [];
C = [];

while line ~= -1
    line = fgets(fd);
    if size(line,2) > 1
        if line(1) == 'N'
            N(size(N,2)+1) = str2double(line(2:size(line,2)-3));
        end
        if line(1) == 'R'
            R(size(R,2)+1) = str2double(line(2:size(line,2)-3));
        end
        if line(1) == 'P'
            P(size(P,2)+1) = str2double(line(2:size(line,2)-3));
        end
        if line(1) == 'C'
            C(size(C,2)+1) = str2double(line(2:size(line,2)-3));
        end
    end
end
fclose(fd);

if (size(R,2) ~= size(C,2)) || (size(R,2) ~= size(P,2)) || (size(R,2) ~= size(N,2)-1)
    echo('Failed to parse lens data, check if data file is formatted properly.')
    ret_opd = 1;
else
    r = sqrt(x.^2 + y.^2);
    aperture = round(r <= D/2);
    mask = round((x.^2+y.^2) < (D/2).^2);
    
    %Starting point/light source
    surfx = px*ones(size(x));
    surfy = py*ones(size(x));
    surfz = pz*ones(size(x));
    
    %Vector of ray trajectory
    vx = x - px;
    vy = y - py;
    vz = C(1)*R(1)+P(1) - C(1)*sqrt( 4*(C(1)*R(1) + P(1))^2 ...
        -4*(x.^2 + y.^2 + P(1)^2 + 2*C(1)*R(1)*P(1)))/2 - pz;
    vl = sqrt(vx.^2+vy.^2+vz.^2);
    
    path = vl;
    opd = path*N(1);
    
    for k = 1:1%size(R,2)-1
        %Previous Boundary point
        psurfx = surfx;
        psurfy = surfy;
        psurfz = surfz;
 
        %Boundary point of Lens2
        surfx = surfx + vx;
        surfy = surfy + vy;
        surfz = surfz + vz;
        surfr = sqrt(surfx.^2 + surfy.^2);
        mask = round((surfx.^2 + surfy.^2) < (D/2).^2);
    
        %Radius segment vector
        rx = (0-surfx)/R(k);
        ry = (0-surfy)/R(k);
        rz = ((C(k)*R(k)+P(k))-surfz)/R(k);
    
        %Source segment vector
        sr = sqrt((surfx - psurfx).^2 + (surfy - psurfy).^2 + (surfz - psurfz).^2);
        sx = (surfx - psurfx)./sr;
        sy = (surfy - psurfy)./sr;
        sz = (surfz - psurfz)./sr;
        
        %r x s = r*s*sin(theta)
        cx = (ry.*sz-sy.*rz);
        cy = (rx.*sz-sx.*rz);
        cz = (rx.*sy-sx.*ry);

        %Snells law for interface
        sinangle1 = sqrt(cx.^2 + cy.^2 + cz.^2); 
        sinangle2 = sinangle1*N(k)/N(k+1);

        %Tangent vector -> r x (r x s)
        tx = (ry.*cz-cy.*rz);
        ty = (rx.*cz-cx.*rz);
        tz = (rx.*cy-cx.*ry);
        tr = sqrt(tx.^2 + ty.^2 + tz.^2);
        tlength = C(k)*R(k)*tan(asin(sinangle2));

        %Propagation vector through medium post boundary
        vx = (tlength.*tx./tr - surfx);
        vy = (tlength.*ty./tr - surfy);
        vz = (tlength.*tz./tr - surfz + P(k)+C(k)*R(k));
        vl = sqrt(vx.^2 + vy.^2 + vz.^2);
        
        a = (vx./vl).^2 + (vy./vl).^2 + (vz./vl).^2;
        b = 2*(surfx.*vx./vl + surfy.*vy./vl + surfz.*vz./vl - (C(k+1)*R(k+1)+P(k+1))*vz./vl);
        c = surfx.^2 + surfy.^2 + surfz.^2 + P(k+1)^2 + 2*(P(k+1)*C(k+1)*R(k+1) -surfz.*C(k+1)*R(k+1) -surfz.*P(k+1));
        path = ((-b - C(k)*sqrt(b.^2 - 4.*a.*c))/2./a);
        opd = opd + path*N(k+1);
    end

end

%imagesc(imag(opd))
%if contains(remove,'tilt')
%    tiltx = x.*mask*sum(sum(opd.*mask.*x));
%    tilty = y.*mask*sum(sum(opd.*mask.*y));
%   ret_opd = opd - tiltx - tilty;
%else
%    ret_opd = opd;
%end
%focus = targ*intersect(752,752)/intersect(752,752)
%
%imagesc(abs(mask.*(ret_opd)))