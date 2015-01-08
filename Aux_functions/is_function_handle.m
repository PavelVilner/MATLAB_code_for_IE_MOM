
function result = is_function_handle(x)

if isa(x, 'function_handle')
    
    result = 1;
    
else
    
    result = 0;
    
end