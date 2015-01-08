
classdef Function2 < handle
    
    properties(SetAccess = protected, GetAccess = public)
        
        f;
        
    end
    
    methods (Access = public)
        
        function fcn = Function2(f_handle)
            
            if is_function_handle(f_handle) && nargin(f_handle) == 2
                
                fcn.f = f_handle;
                
            elseif is_Function2(f_handle)
                
                fcn.f = f_handle.f;
                
            else
                
                error('Wrong input to Function2 constructor!');
                
            end
            
        end
        
        function result = subsref(self, S)
            
            aux_type = {S.type};
            
            if length(aux_type) == 1 && strcmp(aux_type{1}, '()')
                
                if length(self) == 1
                
                    result = self.f(S.subs{:});
                    
                elseif is_index(S.subs{:})
                    
                    result = Function2(self(S.subs{:}));
                     
                end
                
            else
                
                result = builtin('subsref', self, S);
                
            end
            
        end
        
        function varargout = abs(self)
            
            if nargout == 0
                
                aux = self.f;
                
                self.gen_func = @(c1,c2)abs(aux(c1,c2));
                
            elseif nargout == 1
                
                varargout{1} = Function1(self);
                
                abs(varargout{1});
                
            else
                
                error('Wrong amount of output arguments to Function2 abs()!');
                
            end
            
        end
        
        function varargout = exp(self)
            
            if nargout == 0
                
                aux = self.f;
                
                self.gen_func = @(c1,c2)exp(aux(c1, c2));
                
            elseif nargout == 1
                
                varargout{1} = Function1(self);
                
                exp(varargout{1});
                
            else
                
                error('Wrong amount of output arguments to Function2 exp()!');
                
            end
            
        end        
        
        function varargout = plus(self, other)
            
            if is_Function2(self) && is_Function2(other)
                
                if nargout == 0
                    
                    aux1 = self.f;
                    
                    aux2 = other.f;
                    
                    self.f = @(c1,c2)(aux1(c1,c2) + aux2(c1,c2));
                    
                elseif nargout == 1
                    
                    varargout{1} = Function2(self);
                    
                    varargout{1} + other;
                    
                else
                    
                    error('Wrong number of outputs to Function2 plus()!');
                    
                end
                
            elseif is_Function2(self) && is_double(other) && length(other) == 1
                
                aux1 = self.f;
                
                self.f = @(c1,c2)(aux1(c1,c2) + other);
                
            else
                
                error('Wrong inputs to Function2 plus()!');
                
            end
            
        end
        
        function varargout = minus(self, other)
            
            if is_Function2(self) && is_Function2(other)
                
                if nargout == 0
                    
                    aux1 = self.f;
                    
                    aux2 = other.f;
                    
                    self.f = @(c1,c2)(aux1(c1,c2) - aux2(c1,c2));
                    
                elseif nargout == 1
                    
                    varargout{1} = Function2(self);
                    
                    varargout{1} - other;
                    
                else
                    
                    error('Wrong number of outputs to Function2 minus()!');
                    
                end
                
            elseif is_Function2(self) && is_double(other) && length(other) == 1
                
                aux1 = self.f;
                
                self.f = @(c1,c2)(aux1(c1,c2) - other);
                
            else
                
                error('Wrong inputs to Function2 minus()!');
                
            end
            
        end
        
        function varargout = uminus(self)
            
            if nargout == 0
                
                aux1 = self.f;
                
                self.f = @(c1,c2)(-aux1(c1,c2));
                
            elseif nargout == 1
                
                varargout{1} = Function1(self);
                
                varargout{1} = varargout{1};
                
            else
                
                error('Wrong amount of outputs to Function2 uminus()!');
                
            end
            
        end
        
        function varargout = mtimes(self, other)
            
            if is_Function2(self) && is_Function2(other)
                
                if nargout == 0
                    
                    aux1 = self.f;
                    
                    aux2 = other.f;
                    
                    self.f = @(c1,c2)(aux1(c1,c2) * aux2(c1,c2));
                    
                elseif nargout == 1
                    
                    varargout{1} = Function2(self);
                    
                    varargout{1} * other;
                    
                else
                    
                    error('Wrong number of outputs to Function2 mtimes()!');
                    
                end
                
            elseif is_Function2(self) && is_double(other) && length(other) == 1
                
                aux1 = self.f;
                
                self.f = @(c1,c2)(aux1(c1,c2) * other);
                
            else
                
                error('Wrong inputs to Function1 mtimes()!');
                
            end
            
        end
        
        function varargout = mrdivide(self, other)
            
            if is_Function2(self) && is_Function2(other)
                
                if nargout == 0
                    
                    aux1 = self.f;
                    
                    aux2 = other.f;
                    
                    self.f = @(c1,c2)(aux1(c1,c2) / aux2(c1,c2));
                    
                elseif nargout == 1
                    
                    varargout{1} = Function2(self);
                    
                    varargout{1} / other;
                    
                else
                    
                    error('Wrong number of outputs to Function2 mrdivide()!');
                    
                end
                
            elseif is_Function2(self) && is_double(other) && length(other) == 1 && other ~= 0
                
                aux1 = self.f;
                
                self.f = @(c1,c2)(aux1 / other);
                
            else
                
                error('Wrong inputs to Function2 mrdivide()!');
                
            end
            
        end
        
        function varargout = mpower(self, other)
            
            if is_double(other) && length(other) == 1
                
                if nargout == 0
                    
                    aux = self.f;
                    
                    self.f = @(c1,c2)(aux(c1,c2) ^ other);
                    
                elseif nargout == 1
                    
                    varargout{1} = Function2(self);
                    
                    varargout{1} ^ other;
                    
                else
                    
                    error('Wrong amount of outputs to Function2 mpower()!');
                    
                end
                    
            else
                
                error('Wrong inputs to Function2 mpower()!');
                
            end
            
        end
        
        function result = d1(self, dx, varargin)
            
            if nargin == 2 && is_double(dx) && length(dx) == 1 && dx > 0
            
                aux = @(x,y)((self.f(x+dx,y) - self.f(x-dx,y))/2/dx);

                result = Function2(aux);
            
            elseif nargin == 3 && is_double(varargin{:}) && length(varargin{:}) == 2
                
                result = (self.f(varargin{1} + dx,varargin{2}) - self.f(varargin{1} - dx,varargin{2}))/2/dx;
                
            else
                
                error('Wrong inputs to Function2 d1()!')
                
            end
            
        end
        
        function result = d2(self, dy, varargin)
            
            if nargin == 2 && is_double(dy) && length(dy) == 1 && dy > 0
            
                aux = @(x,y)((self.f(x,y+dy) - self.f(x,y-dy))/2/dy);

                result = Function2(aux);
            
            elseif nargin == 3 && is_double(varargin{:}) && length(varargin{:}) == 2
                
                result = (self.f(varargin{1},varargin{2} + dy) - self.f(varargin{1},varargin{2} - dy))/2/dy;
                
            else
                
                error('Wrong inputs to Function2 d2()!')
                
            end
            
        end
        
    end
    
end