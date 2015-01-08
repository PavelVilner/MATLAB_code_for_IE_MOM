function result = is_cyl_coordinate(r, phi, z)

if is_double(r) && isreal(r) &&...
   is_double(phi) && isreal(phi) &&...
   is_double(z) && isreal(z)

    result = 1;
    
else
    
    result = 0;
    
end
   