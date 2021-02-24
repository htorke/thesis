function [S] = lens_array_fractional(lens_index)
  S = 0;
  %Defined Parameters
  %30 centimeter lens diameter
  array_diameter_n = 1;
  lens_diameter = 30e-3;
  %Spatial Resolution
  dl = 1e-4;
  
  %Import lens data
  [aberration,dx,dy,dz] = fetch_data(lens_index);
  
  %Derived Parameters
  side_length_n = (array_diameter_n + 1)/2;
  array_n = array_diameter_n^2 - side_length_n*(side_length_n-1);
  fill_factor = array_n*lens_diameter*lens_diameter/(lens_diameter*array_diameter_n)/(lens_diameter*array_diameter_n);
  lens_area =array_n*pi*lens_diameter*lens_diameter;
  equivalent_aperture_area = pi*(lens_diameter*array_diameter_n/2/dl)^2;

  %Make an array large enough to cover 1 laterally adjacent lens and row above on each side
  [x,y] = meshgrid(-2*lens_diameter:dl:2*lens_diameter);
  field = zeros(size(x,1));
  intensity = zeros(size(x,1));
  aperture = lens(x,y,lens_diameter,aberration);
  energy = 0; 
 
  %Fourier component 
  efl = 498;
  fx = sin(atan(dx/(efl+dz)))/lambda;
  fy = sin(atan(dy/(efl+dz)))/lambda;
  fourier_phase = exp(-sqrt(-1) * 2*pi * (x/fx + y/fy));
  
  %Generate Hex
  for i=-(array_diameter_n-1)/2:(array_diameter_n-1)/2
   for j = -(array_diameter_n-abs(i)-1)/2:(array_diameter_n-abs(i)-1)/2
      %Central lens for location
      intensity = gaussian_lens(x,y,lens_diameter/2);
      field = sqrt(intensity);
      
      %Center-left lens, if applicable
      if(j > -(array_diameter_n-abs(i)-1)/2)
        intensity = gaussian_lens(x+lens_diameter,y,lens_diameter/2);
        field = field + sqrt(intensity);
      end

      %Center-right lens, if applicable
      if(j < (array_diameter_n-abs(i)-1)/2)
        intensity = gaussian_lens(x-lens_diameter,y,lens_diameter/2);
        field = field + sqrt(intensity);
      end
      
      %Upper-left lens, if applicable
      if(j > -(array_diameter_n-abs(i)-1)/2) && (i < (array_diameter_n-1)/2)
        intensity = gaussian_lens(x+lens_diameter/2,y-2*(lens_diameter/2)*sin(pi/3),lens_diameter/2);
        field = field + sqrt(intensity);
      end
      
      %Upper-right lens, if applicable
      if(j < (array_diameter_n-abs(i)-1)/2) && (i < (array_diameter_n-1)/2)
        intensity = gaussian_lens(x-lens_diameter/2,y-2*(lens_diameter/2)*sin(pi/3),lens_diameter/2);
        field = field + sqrt(intensity);
      end
      
      %Lower-left lens, if applicable
      if(j > -(array_diameter_n-abs(i)-1)/2) && (i > -(array_diameter_n-1)/2)
        intensity = gaussian_lens(x+lens_diameter/2,y+2*(lens_diameter/2)*sin(pi/3),lens_diameter/2);
        field = field + sqrt(intensity);
      end
      
      %Lower-right lens, if applicable
      if(j < (array_diameter_n-abs(i)-1)/2) && (i > -(array_diameter_n-1)/2)
        intensity = gaussian_lens(x-lens_diameter/2,y+2*(lens_diameter/2)*sin(pi/3),lens_diameter/2);
        field = field + sqrt(intensity);
      end
      
      %Take the sum of fiber field components and pass them through the lens
      field = field.*aperture;
      
      %Calculate the Fourier component at the target steering angle
      fourier_component = sum(sum(field*fourier_phase));
      energy = energy + fourier_component*exp(sqrt(-1));
      
      imagesc(x,y,field);
      waitforbuttonpress();
     end
  end
  
  %Calculate here
  ideal_energy = 1;
  S = (energy/ideal_energy)^2;
end