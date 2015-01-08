function result = is_pol_vector_data(r, phi, teta)

if is_double(r) && length(r) == 1 &&...
   is_double(phi) && length(phi) == 1 &&...
   is_double(teta) && length(teta) == 1
    
    result = 1;
    
else
    
    result = 0;
    
end
