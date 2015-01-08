
function result = is_Vector(varargin)

if length(varargin) == 1 && isa(varargin{1}, 'Vector') || ~isempty(find(strcmp(superclasses(varargin{1}), 'Vector'),1))
    
    result = 1;
    
else
    
    result = 0;
    
end