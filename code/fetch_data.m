function [filename,x,y,z,efl,d] = fetch_data(run_number)
%Looks up datafile from 'Data' directory of the selected run number.
%Takes in number of run desired, index beginning at 1
%Returns filename, x, y, and z offsets


search_name = sprintf('./data/Run%d_*',run_number);
listing = dir(search_name);
filename = -1;
x=0;
y=0;
z=0;
efl=1;
d=1;

if(size(listing,1) > 0)

    tempname = listing(1).name;
    filename = ['./data/' tempname];
    underscores = strfind(tempname,'_');
    x = str2double(tempname(underscores(1)+2:underscores(2)-1))*1e-3;
    y = str2double(tempname(underscores(2)+2:underscores(3)-1))*1e-3;
    z = str2double(tempname(underscores(3)+2:underscores(4)-1))*1e-3;
    efl = str2double(tempname(underscores(4)+2:underscores(5)-1))*1e-3;
    d = str2double(tempname(underscores(5)+2:size(tempname,2)-4))*1e-3;
  
end
end