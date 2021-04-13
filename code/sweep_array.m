function [sname] = sweep_array(num,angle)
%Loop through array

N_points = 21;
theta_step = 15;

strl = zeros(1,252);
r = zeros(1,252);
theta = zeros(1,252);

sweep_bar = waitbar(0,'Running array sweep');
for i= 1:252
   strl(i) = lens_array(i, num, angle);
   theta(i) = theta_step*((i-1) - mod((i-1),N_points))/N_points;
   r(i) = 3*(mod(i-1,N_points)-(N_points-1)/2);
   waitbar(i/252,sweep_bar,'Running array sweep');
end
close(sweep_bar);
sname = sprintf('./results/N%d_T%d_AC254-500.mat',num,angle);
save(sname,'strl','r','theta');
end