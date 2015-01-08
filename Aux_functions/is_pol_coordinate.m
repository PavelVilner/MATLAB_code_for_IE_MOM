function result = is_pol_coordinate(r, phi, teta)

if is_double(r) && isreal(r) &&...
   is_double(phi) &&isreal(phi) &&...
   is_double(teta) && isreal(teta)
    
    result = 1;
    
else
    
    result = 0;
    
end
