
function result = is_G(n)

if isa(n, 'G') || ~isempty(find(strcmp(superclasses(n),'G'),1))
    
    result = 1;
    
else
    
    result = 0;
    
end