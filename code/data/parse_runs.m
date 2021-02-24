clear;
filename = 'all_runs.txt';
fd = fopen(filename,'r');
maxrun = 252;

n = 0;
while(n < maxrun)
  run = fgetl(fd);
  n = str2double(run(4:size(run,2)));

  line = fgetl(fd);
  x = str2double(line(3:size(line,2)));
  line = fgetl(fd);
  y = str2double(line(3:size(line,2)));
  line = fgetl(fd);
  z = str2double(line(3:size(line,2)));
  
  writefile = sprintf('Run%d_x%f_y%f_z%f.txt',n,x,y,z);

  f2 = fopen(writefile,'w');
  while(!strcmp(line,'===================='))
    line = fgetl(fd);
    fwrite(f2,line);
    fwrite(f2,10);
  end
  fclose(f2);  
end

fclose(fd);
clear;