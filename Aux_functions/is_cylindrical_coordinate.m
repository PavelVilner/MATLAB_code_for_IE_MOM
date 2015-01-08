function result = is_cylindrical_coordinate(r, phi, z)

if is_double(r) && isreal(r) && isempty(find(r < 0,1)) &&...
   is_double(phi) && isreal(phi) && isempty(find(phi > 2*pi || phi < 0,1)) &&...
   is_double(z) && isreal(z)

    result = 1;
    
else
    
    result = 0;
    
end
   