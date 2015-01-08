
classdef Curve < handle
    
    properties (GetAccess = public, SetAccess = protected)
        
        c1;
        
        c2;
        
        c3;
        
        du;
        
    end
    
    methods (Access = public)
        
        function crv = Curve(new_c1, new_c2, new_c3, new_du)
            
            if is_Function1(new_c1) && is_Function1(new_c2) && is_Function1(new_c3) &&...
               is_double(new_du) && length(new_du) == 1 && new_du > 0;
           
                crv.c1 = new_c1;
                
                crv.c2 = new_c2;
                
                crv.c3 = new_c3;
                
                crv.du = new_du;
                
            else
                
                error('Wrong input to Curve constructor!');
                
            end
            
        end
        
        function result = subsref(self, S)
            
            aux_type = {S.type};
            
            if length(aux_type) == 1 && strcmp(aux_type{1}, '()')
                
                result = Vector(self.c1(S.subs{:}), self.c2(S.subs{:}), self.c3(S.subs{:}));
                
            else
                
                result = builtin('subsref', self, S);
                
            end
            
        end
        
        function result = dL(self, u, varargin)
            
            result = Vector(self.c1.d(self.du, u)*self.du,...
                     self.c2.d(self.du, u)*self.du,...
                     self.c3.d(self.du, u)*self.du);
            
            if nargin == 3
                
                result.convert_to(varargin{1});
                
            elseif nargin > 3
                
                error('Wrong amount of input arguments to Curve dL()!');
                
            end
                
        end
        
    end
    
end