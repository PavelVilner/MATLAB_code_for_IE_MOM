function result = is_Vector_type(n)

if strcmp(n, 'cart') || strcmp(n, 'cyl') || strcmp(n, 'pol')
    
    result = 1;
    
else
    
    result = 0;
    
end