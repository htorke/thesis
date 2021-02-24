clear;
dl = 0.01;
[x,y] = meshgrid(-10:dl:10);

out_width = 600;

sub_cell = zeros(out_width);

fx = 30;
fy = -20;

%Image we will try to reproduce
circ = round(sqrt(x.^2 + y.^2) <= 0.5).*exp(sqrt(-1)*2*pi*(x*fx + y*fy));
imagesc(fftshift(abs(fft2(circ))))

%Pad with zeros so that we can evenly divide target into blocks
pad = zeros(size(sub_cell,1)*ceil(size(circ,1)/out_width),size(sub_cell,2)*ceil(size(circ,2)/out_width));
pad(1:size(circ,1),1:size(circ,2)) = circ;

%Loop through all block tiles in target
for i=1:size(pad,1)/out_width
  for j=1:size(pad,1)/out_width
    sub_cell = pad(1+out_width*(i-1):out_width*i,1+out_width*(j-1):out_width*j);
    imagesc(abs(sub_cell));
    waitforbuttonpress()
  end
end

