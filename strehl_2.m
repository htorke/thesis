function [S] = strehl_2(Ei,Eo)
mask = round(Eo>0);

Ii = abs(Ei).^2;
Iideal = sum(sum(Ii))*mask/sum(sum(mask));
Eideal = sqrt(Iideal);

S = (abs(sum(sum(Eo)))/abs(sum(sum(Eideal))))^2;

end