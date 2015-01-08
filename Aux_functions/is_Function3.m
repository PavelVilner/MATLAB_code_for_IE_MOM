
function result = is_Function3(x)

if isa(x, 'Function3') || ~isempty(find(strcmp(superclasses(x), 'Function3'),1))
    
    result = 1;
    
else
    
    result = 0;
    
end