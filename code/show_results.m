function [retval] = show_results()
[file,path] = uigetfile('*.mat','Select datafile to display','.\results\');
if isequal(file,0)
   disp('User selected Cancel');
   retval = 0;
else
   disp(['User selected ', fullfile(path,file)]);
   load(fullfile(path,file));

    row = 1+(max(r)-min(r))/(r(2)-r(1));
    column = size(strl,2)/row;

    rho = transpose(reshape(r,row,column));
    phi = transpose(reshape(theta,row,column));
    s = transpose(reshape(strl,row,column));

    %Add 1 row to each variable to complete loop
    rho(column+1,:) = rho(1,row:-1:1);
    phi(column+1,:) = phi(1,:);
    s(column+1,:) = s(1,:);

    x = rho.*cos(2*pi*phi/360);
    y = rho.*sin(2*pi*phi/360);

    figure;
    p= pcolor(x,y,s);
    p.FaceColor = 'interp';
    %p.CDataMapping = 'direct';
    
    underscores = strfind(file,'_');
    
    n = round(str2double(file(2:underscores(1)-1)))
    angle = round(str2double(file(underscores(1)+2:underscores(2)-1)))
    
    t = sprintf('Pitch angle: %d, Subapertures: %d, On-axis S: %f',angle,n^2*(3/4)+(1/4),max(max(s)))
    
    title(t);
    colorbar;

    figure;
    plot(s(1,:));
    
    retval = max(max(s));
end
end
