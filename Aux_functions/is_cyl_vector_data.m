function result = is_cyl_vector_data(r, phi, z)

if is_double(r) && length(r) == 1 &&...
   is_double(phi) && length(phi) == 1 &&...
   is_double(z) && length(z) == 1

    result = 1;
    
else
    
    result = 0;
    
end
   