
classdef Surface < handle
    
    properties (SetAccess = protected, GetAccess = public)
        
        generating_function;
                        
    end
    
    methods (Access = public)
        
        function Srf = Surface(new_gen_function)
        
        end
        
        function result = pos(u,v)
            
        end
        
        function result = dS(u,v)
            
        end
        
        function result = n(u,v)
            
        end
        
    end
    
    methods (Access = protected)
        
    end
    
end