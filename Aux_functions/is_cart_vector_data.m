
function result = is_cart_vector_data(x,y,z)

if is_double(x) && length(x) == 1 &&...
   is_double(y) && length(y) == 1 &&...
   is_double(z) && length(z) == 1
    
    result = 1;
    
else
    
    result = 0;
    
end

