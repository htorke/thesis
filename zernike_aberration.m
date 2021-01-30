AFOC;

file = 'singlet_zernike.txt';

fd = fopen(file,'r');

i=0;
fgetl(fd);
fgetl(fd);
fgetl(fd);

abberation = zeros(size(x));

for n = 0:7
  for m = -n:2:n
    i = i+1;
    
    a = fgetl(fd);
    term = strfind(a,':');
    if(strfind(a(1:term-1),'--'))
      coeff(i) = coeff(i-1);
    else
      if(strfind(a(1:term-1),'e'))
        ex = strfind(a(1:term-1),'e')
        base = str2double(a(1:ex-1))
        order = str2double(a(ex+1:term-1))
        coeff(i) = base *10^(order);
      else
        coeff(i) = str2double(a(1:term-1));
      end
    end
    
    
    
    
    subplot(6,6,i);
    zn = zernike(x,y,n,m,0.03);
    imagesc(zn);
    abberation = abberation + zn*coeff(i);
  end
end

figure;
imagesc(abberation);