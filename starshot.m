%Defined Parameters
%30 centimeter lens diameter
array_diameter_n = 90000;
lens_diameter = 30e-2;


%Derived Parameters
side_length_n = (array_diameter_n + 1)/2;
array_n = array_diameter_n^2 - side_length_n*(side_length_n-1);

fill_factor = array_n*lens_diameter*lens_diameter/(lens_diameter*array_diameter_n)/(lens_diameter*array_diameter_n);