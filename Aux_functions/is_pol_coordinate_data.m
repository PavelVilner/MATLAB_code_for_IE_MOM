function result = is_pol_coordinate_data(r, phi, teta)

if is_double(r) && length(r) == 1 && isreal(r) &&...
   is_double(phi) && length(phi) == 1 && isreal(phi) &&...
   is_double(teta) && length(teta) == 1 && isreal(teta)
    
    result = 1;
    
else
    
    result = 0;
    
end
