function result = is_int(n)

if is_double(n) && isreal(n) && isempty(find(floor(n) ~= n,1))
    
    result = 1;
    
else
    
    result = 0;
    
end    