function [filename,x,y,z] = fetch_data(run_number)
%Looks up datafile from 'Data' directory of the selected run number.
%Takes in number of run desired, index beginning at 1
%Returns filename, x, y, and z offsets

listing = dir('./data/');
filename = -1;
x=0;
y=0;
z=0;

for i = 1:size(listing,1)
  tempname = listing(i).name;
  prefix = sprintf('Run%d_x',run_number);
  if size(tempname,2) > size(prefix,2)
    if strcmp(prefix, tempname(1:size(prefix,2)))
      filename = ['./data/' tempname];  
      underscores = strfind(tempname,'_');
      x = str2double(tempname(underscores(1)+2:underscores(2)-1));
      y = str2double(tempname(underscores(2)+2:underscores(3)-1));
      z = str2double(tempname(underscores(3)+2:size(tempname,2)-4));
    end
  end
end


end