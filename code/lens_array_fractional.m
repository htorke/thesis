function [S, S_Ideal] = lens_array_fractional(run_index)

if nargin < 1
   run_index = 11; 
end

  %Defined Parameters
  %30 milimeter lens diameter
  array_diameter_n = 7;
  lens_diameter = 30e-3;
  %Spatial Resolution
  dl = 1e-4;
  lambda = 0.58756e-6;
  efl = 498.335807e-3;
  
  n = 0;
  w = waitbar(n,'Evaluating array');
  
  %Derived Parameters
  side_length_n = (array_diameter_n + 1)/2;
  array_n = array_diameter_n^2 - side_length_n*(side_length_n-1);
  
  %Get OSLO data
  [aberration,dx,dy,dz] = fetch_data(run_index);
  theta_x = atan(dx/efl)*360/2/pi;
  theta_y = atan(dy/efl)*360/2/pi;


  %Make an array large enough to cover 1 lens
  [x,y] = meshgrid(-lens_diameter:dl:lens_diameter);
  field_f = zeros(size(x,1));
  power = 0;
  

  %Calculate Ideal Strehl
  fill_factor = array_n*lens_diameter*lens_diameter/(lens_diameter*array_diameter_n)/(lens_diameter*array_diameter_n);
  [e,p] = gaussian_lens(x,y,lens_diameter/2,0.447,dl,dx,dy,dz);
  S_gauss = strehl(e,p,x,y,lens_diameter);
  S_Ideal = fill_factor * S_gauss;
 
  
  %Generate Hex
  for i=-(array_diameter_n-1)/2:(array_diameter_n-1)/2
   for j = -(array_diameter_n-abs(i)-1)/2:(array_diameter_n-abs(i)-1)/2

	  [field,sub_p] = gaussian_lens(x,y,lens_diameter/2,0.447,dl,-dx,-dy,dz);
      aperture = lens(x-lens_diameter*j,y-2*(lens_diameter/2)*sin(pi/3)*i,lens_diameter,aberration);
      field = field .*aperture;
      power = power + sub_p;

      %Shift fft in space
      fourier_phase = exp(-sqrt(-1)*2*pi*((lens_diameter*j)*(2/(max(max(x))-min(min(x)))) + (2*(lens_diameter/2)*sin(pi/3)*i)*(5/(max(max(y))-min(min(y))))));
      %Calculate the Fourier component at the target steering angle
      fourier_component = fftshift(fft2(field)).*fourier_phase;
      field_f = field_f + fourier_component;
      
%      energy = energy + fourier_component*exp(sqrt(-1));
      
       n = n + 1;
       waitbar(n/array_n,w,'Evaluating array');
    end
  end
  close(w);



%Plot equivalent aperture
imagesc(x(1,:),y(:,1), abs(field_f));
title('Far Field')

  %Calculate here
S = strehl(ifft2(fftshift(field_f)),power,x,y,array_diameter_n*lens_diameter,theta_x,theta_y,lambda);
end