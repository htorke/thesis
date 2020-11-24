clear;

sim_length = 1000;
dl = 0.0005;
[x,y] = meshgrid(-0.3:dl:0.3);
radius = 0.15;
max_variance = 2*pi/100;

E0 = round(sqrt(x.^2 + y.^2)< radius);
n = sum(sum(E0));

sigma = zeros(1,sim_length);
mean = zeros(1,sim_length);
S = zeros(1,sim_length);

for k = 1:sim_length
    v = max_variance*k/sim_length;
    theta = E0.*rand(size(x))*pi;

    %Eliminate the random drift to get a mean of 0
    theta = theta - E0*sum(sum(theta))/n;

    %Calculate original std dev
    sig = sqrt( sum(sum((theta).^2))/n );

    %Adjust spread to acheive desired std dev
    theta = theta*sqrt(v)/sig;

    %Verify std dev
    sigma(k) = sqrt( sum(sum((theta).^2))/n );
    %Verify 0 mean
    mean(k) = sum(sum(theta))/n;

    %Use theta to create phase error
    phase_noise = exp(sqrt(-1)*theta);

    %Post aperture field
    E1 = E0.*phase_noise;

    %Calculate Strehl
    S(k) = strehl(E0,E1);
end

subplot(1,2,1);
title('Variance')
xlabel('Expected Variance')
ylabel('Produced Variance')
plot(max_variance*(1:sim_length)/sim_length,sigma.^2);

subplot(1,2,2);
title('Strehl Ratio')
xlabel('Expected Variance')
ylabel('S')
plot(max_variance*(1:sim_length)/sim_length,S);