
classdef Coordinate < Vector
    
    properties
        
    end
    
    methods (Access = public)
        
        function crd = Coordinate(varargin)
            
                        
            if nargin == 1 && ~is_Coordinate(varargin{1})
                
                error('Wrong arguments to Coordinate constructor!');
            
            elseif nargin == 2 && ~is_cart_coordinate_data(varargin{:}, 0)
                
                error('Wrong arguments to Coordinate constructor!');
                
            elseif nargin == 3 && ~is_cart_coordinate_data(varargin{:});
                
                error('Wrong arguments to Coordinate constructor!');
                
            elseif nargin == 4 &&...
                   ~(is_cart_coordinate_data(varargin{1:3}) && strcmp(varargin{4}, 'cart')) &&...
                   ~(is_cyl_coordinate_data(varargin{1:3}) && strcmp(varargin{4}, 'cyl')) &&...
                   ~(is_pol_coordinate_data(varargin{1:3}) && strcmp(varargin{4}, 'pol'))
               
               error('Wrong arguments to Coordinate constructor!');
                
            elseif nargin > 4
                
                error('Wrong amount of arguments to Coordinate constructor!');
                
            end
            
            crd = crd@Vector(varargin{:});
        
        end       
        
    end
    
end