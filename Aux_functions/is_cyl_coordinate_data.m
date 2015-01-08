function result = is_cyl_coordinate_data(r, phi, z)

if is_double(r) && length(r) == 1 && isreal(r) &&...
   is_double(phi) && length(phi) == 1 && isreal(phi) &&...
   is_double(z) && length(z) == 1 && isreal(z)

    result = 1;
    
else
    
    result = 0;
    
end
   