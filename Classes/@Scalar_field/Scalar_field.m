
classdef Scalar_field < handle
    
    properties (SetAccess = protected, GetAccess = public)
        
        gen_func;
        
        in_type;
        
    end
    
    methods (Access = public)
        
        function Sclr_f = Scalar_field(varargin)
            
            if nargin == 1 && is_Scalar_field(varargin{1})
                
                Sclr_f.gen_func = varargin{1}.gen_func;
                
                Sclr_f.in_type = varargin{1}.in_type;
                
            elseif nargin == 2
            
                if is_Function3(varargin{1}) && is_Vector_type(varargin{2})

                    Sclr_f.gen_func = varargin{1};

                    Sclr_f.in_type = varargin{2};

                else

                    error('Wrong inputs to Scalar_field constructor!');

                end
                
            else
                
                error('Wrong amount of inputs Scalar_field constructor!')
                
            end
        
        end
        
        function result = subsref(self, S)
            
            aux_type = {S.type};
            
            if length(aux_type) == 1 && strcmp(aux_type{1}, '()')
                
                if is_Coordinate(S.subs{:})
                    
                    S.subs{:}.convert_to(self.in_type);
                    
                    result = self.gen_func(S.subs{:}.value(1), S.subs{:}.value(2), S.subs{:}.value(3));
                    
                else 
                    
                    error('Wrong input to Scalar_field subsref()!');
                    
                end
                
            else
                
                result = builtin('subsref', self, S);
                
            end
            
        end
        
        function varargout = abs(self)
            
            if nargout == 0
                
                aux = self.gen_func;
                
                self.gen_func = abs(aux);
                
            elseif nargout == 1
                
                varargout{1} = Scalar_field(self);
                
                abs(varargout{1});
                
            else
                
                error('Wrong amount of output arguments to Scalar_field abs()!');
                
            end
            
        end
        
        function varargout = exp(self)
            
            if nargout == 0
                
                aux = self.gen_func;
                
                self.gen_func = exp(aux);
                
            elseif nargout == 1
                
                varargout{1} = Scalar_field(self);
                
                exp(varargout{1});
                
            else
                
                error('Wrong amount of output arguments to Scalar_field exp()!');
                
            end
            
        end
        
        function varargout = plus(self, other)
            
            if is_Scalar_field(self) && is_Scalar_field(other)
                
                if nargout == 0
                    
                    aux = self.gen_func;
                    
                    self.gen_func = aux + other.gen_func;
                    
                elseif nargout == 1
                    
                    varargout{1} = Scalar_field(self);
                    
                    varargout{1} + other;
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field plus()!');
                    
                end               
            
            elseif is_Scalar_field(self) && is_double(other) && length(other) == 1
                
                if nargout == 0
                    
                    aux = self.gen_func;
                    
                    self.gen_func = aux + other.gen_func;
                    
                elseif nargout == 1
                    
                    varargout{1} = Scalar_field(self);
                    
                    varargout{1} + other;
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field plus()!');
                    
                end
                
            else
                
                error('Wrong inputs to Scalar_field plus()!');
                
            end
            
        end
        
        function varargout = minus(self, other)
            
             if is_Scalar_field(self) && is_Scalar_field(other)
                
                if nargout == 0
                    
                    aux = self.gen_func;
                    
                    self.gen_func = aux - other.gen_func;
                    
                elseif nargout == 1
                    
                    varargout{1} = Scalar_field(self);
                    
                    varargout{1} - other;
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field minus()!');
                    
                end               
            
            elseif is_Scalar_field(self) && is_double(other) && length(other) == 1
                
                if nargout == 0
                    
                    aux = self.gen_func;
                    
                    self.gen_func = aux - other.gen_func;
                    
                elseif nargout == 1
                    
                    varargout{1} = Scalar_field(self);
                    
                    varargout{1} - other;
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field minus()!');
                    
                end
                
            else
                
                error('Wrong inputs to Scalar_field minus()!');
                
            end
            
        end
        
        function varargout = mtimes(self, other)
            
            if is_Scalar_field(self) && is_Scalar_field(other)
                
                if nargout == 0
                    
                    aux = self.gen_func;
                    
                    self.gen_func = aux * other.gen_func;
                    
                elseif nargout == 1
                    
                    varargout{1} = Scalar_field(self);
                    
                    varargout{1} * other;
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field mtimes()!');
                    
                end               
            
            elseif is_Scalar_field(self) && is_double(other) && length(other) == 1
                
                if nargout == 0
                    
                    aux = self.gen_func;
                    
                    self.gen_func = aux * other.gen_func;
                    
                elseif nargout == 1
                    
                    varargout{1} = Scalar_field(self);
                    
                    varargout{1} * other;
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field mtimes()!');
                    
                end
                
            elseif is_Scalar_field(self) && is_Vector(other) 
                
                if nargout == 1
                    
                    other.convert_to(self.in_type);
                    
                    varargout{1} = Vector_field(self.gen_func*other.value(1),...
                                                self.gen_func*other.value(2),...
                                                self.gen_func*other.value(3),self.in_type);
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field mtimes()!');
                    
                end                   
                
            else
                
                error('Wrong inputs to Scalar_field mtimes()!');
                
            end
            
        end
        
        function varargout = mrdivide(self, other)
            
            if is_Scalar_field(self) && is_Scalar_field(other)
                
                if nargout == 0
                    
                    aux = self.gen_func;
                    
                    self.gen_func = aux / other.gen_func;
                    
                elseif nargout == 1
                    
                    varargout{1} = Scalar_field(self);
                    
                    varargout{1} / other;
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field mrdivide()!');
                    
                end
            
            elseif is_Scalar_field(self) && is_double(other) && length(other) == 1
                
                if nargout == 0
                    
                    aux = self.gen_func;
                    
                    self.gen_func = aux / other;
                    
                elseif nargout == 1
                    
                    varargout{1} = Scalar_field(self);
                    
                    varargout{1} / other;
                    
                else
                    
                    error('Wrong amount of outputs to Scalar_field mrdivide()!');
                    
                end
                
            else
                
                error('Wrong inputs to Scalar_field mrdivide()!');
                
            end
            
        end
        
        function result = Grad(self, dc1, dc2, dc3, varargin)
            
            if ~is_proper_d(dc1) || ~is_proper_d(dc2) || ~is_proper_d(dc3)
                
                error('Wrong inputs to Scalar_field Grad() d values!');
                                           
            end
            
            if strcmp(self.in_type, 'cart')

                f1 = self.gen_func.d1(dc1);

                f2 = self.gen_func.d2(dc2);

                f3 = self.gen_func.d3(dc3);

            elseif strcmp(self.in_type, 'cyl')

                f1 = self.gen_func.d1(dc1);
                
                f2 = self.gen_func.d2(dc2) / Function3(@(r,phi,teta)r);

                f3 = self.gen_func.d3(dc3);

            elseif strcmp(self.in_type, 'pol')

                f1 = self.gen_func.d1(dc1);
                
                f2 = self.gen_func.d2(dc2) / Function3(@(r,phi,teta)r*sin(teta));

                f3 = self.gen_func.d3(dc3) / Function3(@(r,phi,teta)r);

            end
            
            if nargin == 4

                result = Vector_field(f1, f2, f3, self.in_type);
                
            elseif nargin == 5
                
                if is_Vector(varargin{1})
                    
                    varargin{1}.convert_to(self.in_type);
                
                    result = Vector(f1(varargin{1}.value(1), varargin{1}.value(2), varargin{1}.value(3)),...
                                    f2(varargin{1}.value(1), varargin{1}.value(2), varargin{1}.value(3)),...
                                    f3(varargin{1}.value(1), varargin{1}.value(2), varargin{1}.value(3)),...
                                    self.in_type);
                
                else
                    
                    error('Wrong input to Scalar_field Grad() position!');
                    
                end
                
            else
                
                error('Wrong amount of inputs to Scalar_field Grad()!');
                
            end
            
        end
        
    end
    
end