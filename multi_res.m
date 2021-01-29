grid_size = 129;
square_size = 65;
grid_spacing = (-(grid_size-1)/2:(grid_size-1)/2)*(square_size/10-.1);

square = zeros(grid_size,grid_size);
square((grid_size+1)/2-(square_size-1)/2:(grid_size+1)/2+(square_size-1)/2,(grid_size+1)/2-(square_size-1)/2:(grid_size+1)/2+(square_size-1)/2) = ones(51,51);

grid2_size = (grid_size-1)*8+1;




imagesc(grid_spacing,grid_spacing,square)