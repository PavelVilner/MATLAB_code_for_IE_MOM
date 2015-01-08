
function result = is_Scalar_field(n)

if isa(n, 'Scalar_field') || ~isempty(find(strcmp(superclasses(n), 'Scalar_field'),1))
    
    result = 1;
    
else
    
    result = 0;
    
end