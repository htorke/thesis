function [abberation] = zernike(x,y,r,file)

fd = fopen(file,'r');

i=0;
fgetl(fd);
fgetl(fd);
fgetl(fd);
fgetl(fd);

abberation = zeros(size(x));

for np = 0:5
  for m = np:-1:0
    for mp = 1:-2: -1
      %Skip case m=0 mp=-1 because m=0 has no double
      if ~((mp==-1)&(m==0))
        n = 2*np - m;
        i = i+1;
    
        a = fgetl(fd);
        term = strfind(a,':');
        if(strfind(a(1:term-1),'--'))
          coeff(i) = 0;
        else
          if(strfind(a(1:term-1),'e'))
            ex = strfind(a(1:term-1),'e');
            base = str2double(a(1:ex-1));
            order = str2double(a(ex+1:term-1));
            coeff(i) = base *10^(order);
          else
            coeff(i) = str2double(a(1:term-1));
          end
        end
    
        zn = zernike_poly(y,x,n,mp*m,r);
        abberation = abberation + zn*coeff(i);

%        subplot(6,6,i);
%        imagesc(zn);
%        set(gca,'YDir','normal');
      end
    end
  end
end

end