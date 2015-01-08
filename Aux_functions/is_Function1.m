
function result = is_Function1(x)

if isa(x, 'Function1') || ~isempty(find(strcmp(superclasses(x), 'Function1'),1))
    
    result = 1;
    
else
    
    result = 0;
    
end