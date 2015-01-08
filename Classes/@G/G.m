
classdef G < handle
    
    properties (GetAccess = public, SetAccess = protected)
        
        k;
        
        mu;
        
        string;
        
    end
    
    methods (Access = public)
        
        function grn = G(varargin)
            
            if nargin == 1
                
                if is_G(varargin{1})
                    
                    grn.mu = varargin{1}.mu;
                    
                    grn.k = varargin{1}.k;
                    
                    grn.string = varargin{1}.string;
                
                elseif is_double(varargin{1}) && length(varargin{1}) == 1 && imag(varargin{1}) <= 0
                
                    grn.k = varargin{1};
                    
                    grn.mu = 4*pi*1e-7;
                    
                    grn.string = ['(',num2str(grn.mu),')/4/pi*exp(-1i*(',num2str(grn.k),')*sqrt((c1-xs)^2+(c2-ys)^2+(c3-zs)^2))/sqrt((c1-xs)^2+(c2-ys)^2+(c3-zs)^2)'];
                    
                else
                    
                    error('Wrong input to G constructor!');
                    
                end
                
            elseif nargin == 2 &&...
                   is_double(varargin{1}) && length(varargin{1}) == 1 && imag(varargin{1}) <= 0 &&...
                   is_double(varargin{2}) && length(varargin{2}) == 1
               
               grn.k = varargin{1};
               
               grn.mu = varargin{2};
               
               grn.string = ['(',num2str(grn.mu),')/4/pi*exp(-1i*(',num2str(grn.k),')*sqrt((c1-xs)^2+(c2-ys)^2+(c3-zs)^2))/sqrt((c1-xs)^2+(c2-ys)^2+(c3-zs)^2)'];
               
            else
                
                error('Wrong input to G constructior!');
                
            end
            
        end
        
        function result = subsref(self, S)
            
            aux_type = {S.type};
            
            aux_subs = S.subs;
            
            if length(aux_type) == 1 && strcmp(aux_type{1}, '()')
                
                if length(aux_subs) == 2 && is_Coordinate(aux_subs{1}) && is_Coordinate(aux_subs{2})
                                                            
                    R = abs(aux_subs{2} - aux_subs{1});
                    
                    result = self.mu/4/pi/R * exp(-1j*self.k*R);
                    
                elseif length(aux_subs) == 2 && strcmp(aux_subs{1}, 'source') && is_Coordinate(aux_subs{2})
                    
                    aux_subs{2}.convert_to('cart');
                    
                    x = aux_subs{2}.value(1);
                    
                    y = aux_subs{2}.value(2);
                    
                    z = aux_subs{2}.value(3);
                    
                    K = self.k;
                    
                    MU = self.mu;
                    
                    clear('self', 'aux_subs', 'aux_type', 'S');
                                       
                    result = Scalar_field(Function3(@(c1,c2,c3)MU/4/pi*exp(-1i*K*sqrt((c1 - x)^2 + (c2 - y)^2 + (c3 - z)^2))/sqrt((c1 - x)^2 + (c2 - y)^2 + (c3 - z)^2)), 'cart');
                    
                    clear('x','y','z','MU','K');
                    
                else
                    
                    error('Wrong input to G subsref()!');
                    
                end
                
            else
                
                result = builtin('subsref', self, S);
                
            end
            
        end
        
    end
    
end