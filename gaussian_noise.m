function [ noise, u, sigma ] = gaussian_noise( dim, mean, std_dev )
%Calculates Gaussian noise with a given mean and standard deviation

% Gaussian Curve
% CDF = 0.5*(1 + erf((x-mean)/(sigma*sqrt(2))))
% 2*CDF - 1 = erf((x-mean)/(sigma*sqrt(2)))
% x = mean + erfinv(2*CDF - 1)*sigma*sqrt(2)

%Calculate random samples from normal distribution to get desired sigma
noise = erfinv(2*rand(dim) - 1)*std_dev*sqrt(2);


%Add DC component to set mean to desired value
noise = noise -(sum(noise(:))/numel(noise)-mean);

%Uncomment to print out values for verification
n_sq = noise.^2;
sigma = sqrt(sum(n_sq(:))/numel(n_sq)  - (sum(noise(:))/numel(noise)).^2);
u = sum(noise(:))/numel(noise);
end

