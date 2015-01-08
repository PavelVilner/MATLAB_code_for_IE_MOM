function result = is_polar_cooordinate(r, phi, teta)

if is_double(r) && isreal(r) && isempty(find(r < 0,1)) &&...
   is_double(phi) &&isreal(phi) && isempty(find(phi < 0 || phi > 2*pi,1)) &&...
   is_double(teta) && isreal(teta) && isempty(find(teta < 0 || teta > pi,1))
    
    result = 1;
    
else
    
    result = 0;
    
end
