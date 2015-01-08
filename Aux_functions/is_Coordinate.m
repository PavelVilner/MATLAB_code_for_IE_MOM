
function result = is_Coordinate(varargin)

if length(varargin) == 1 && isa(varargin{1}, 'Coordinate') || ~isempty(find(strcmp(superclasses(varargin{1}), 'Coordinate'),1))
    
    result = 1;
    
else
    
    result = 0;
    
end