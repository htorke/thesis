function parse_runs(maxrun)

log_location = 'C:\Users\Public\Documents\OSLO 64bit EDU\private\oslog.txt';

fd = fopen(log_location,'r');
fw = fopen('./data/all_runs.txt','w');

if fd ~= 0 
    
    delete('./data/Run*.txt');

    line = 0;
    while(~strcmp(line,'Beginning sweep'))
        line = fgetl(fd);
    end
    
    while line ~= -1
        line = fgets(fd);
        fwrite(fw,line);
    end
    
    fclose(fd);
    fclose(fw);
    
    delete(log_location);
end

filename = './data/all_runs.txt';
fd = fopen(filename,'r');

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
  
  writefile = sprintf('./data/Run%d_x%f_y%f_z%f.txt',n,x,y,z);

  f2 = fopen(writefile,'w');
  while(~strcmp(line,'===================='))
    line = fgetl(fd);
    fwrite(f2,line);
    fwrite(f2,10);
  end
  fclose(f2);  
end

fclose(fd);
clear;
end