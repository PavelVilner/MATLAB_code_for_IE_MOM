function result = is_index(n)

if is_int(n) && isempty(find(n <= 0,1))
    
    result = 1;
    
else
    
    result = 0;
    
end