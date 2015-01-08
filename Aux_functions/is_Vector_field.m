
function result = is_Vector_field(n)

if isa(n, 'Vector_field') || ~isempty(find(strcmp(superclasses(n), 'Vector_field'),1))
    
    result = 1;
    
else
    
    result = 0;
    
end