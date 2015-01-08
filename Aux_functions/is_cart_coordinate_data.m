
function result = is_cart_coordinate_data(x,y,z)

if is_double(x) && length(x) == 1 && isreal(x) &&...
   is_double(y) && length(y) == 1 && isreal(y) &&...
   is_double(z) && length(z) == 1 && isreal(z)
    
    result = 1;
    
else
    
    result = 0;
    
end

