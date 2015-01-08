
function result = is_Function2(x)

if isa(x, 'Function2') || ~isempty(find(strcmp(superclasses(x), 'Function2'),1))
    
    result = 1;
    
else
    
    result = 0;
    
end