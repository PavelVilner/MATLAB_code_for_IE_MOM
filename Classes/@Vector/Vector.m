classdef Vector < handle
    
    properties (SetAccess = protected, GetAccess = public)
        
        type;
        
        value;        
        
    end
    
    methods (Access = public)
        
        function vec = Vector(varargin)
            
            if nargin == 1 && is_Vector(varargin{1})
                
                vec.type = varargin{1}.type;
                
                vec.value = varargin{1}.value;
            
            elseif nargin == 2 && is_cart_vector_data([varargin{:} 0])
                
                vec.type = 'cart';
                
                vec.value = [varargin{:} 0];
                
            elseif nargin == 3 && is_cart_vector_data(varargin{:})
                
                vec.type = 'cart';
                
                vec.value = [varargin{:}];
                
            elseif nargin == 4
                
                if vec.is_vector_type(varargin{4})
                    
                    if is_cart_vector_data(varargin{1:3}) && strcmp(varargin{4}, 'cart')
                        
                        vec.type = 'cart';
                
                        vec.value = [varargin{1:3}];
                        
                    elseif is_pol_vector_data(varargin{1:3}) && strcmp(varargin{4}, 'pol')
                        
                        vec.type = 'pol';
                        
                        vec.value = [varargin{1:3}];
                        
%                         if varargin{1} < 0
%                             
%                             varargin{1} = -varargin{1};
%                             
%                             varargin{2} = varargin{2} + pi;
%                             
%                             varargin{3} = pi - varargin{3};
%                             
%                         end
                        
                    elseif is_cyl_vector_data(varargin{1:3}) && strcmp(varargin{4}, 'cyl')
                        
                        vec.type = 'cyl';
                        
                        vec.value = [varargin{1:3}];
                        
%                         if varargin{1} == 0
%                             
%                             vec.value = [varargin{1:3}];
%                             
%                         else
%                 
%                             if varargin{1} < 0
%                                 
%                                 vec.value = [-varargin{1}, varargin{2}+pi, varargin{3}];
%                                 
%                             else
%                             
%                                 vec.value = [varargin{1:3}];
%                             
%                             end
%                         
%                         end
                    
                    else
                        
                        error('Wrong arguments in Vector constructor!');
                        
                    end
                    
                end
                
            else
                
                error('Wrong input to Vector class constructor!');
                
            end
            
        end
        
        function result = abs(self)
            
            aux = conj(self);
            
            result = (self * aux)^0.5;
            
        end
        
        function varargout = conj(self)
            
            if nargout == 0
                
                self.value = conj(self.value);
                
            elseif nargout == 1
                
                varargout{1} = Vector(self);
                
                varargout{1}.conj;
                
            else
                
                error('Wrong amount of outputs to Vector conj()!');
                
            end
            
        end
        
        function varargout = real(self)
            
            if nargout == 0
                
                self.value = real(self.value);
                
            elseif nargout == 1
                
                varargout{1} = Vector(self);
                
                varargout{1}.real;
                
            else
                
                error('Wrong amount of outputs to Vector real()!');
                
            end
            
        end
        
        function varargout = imag(self)
            
            if nargout == 0
                
                self.value = imag(self.value);
                
            elseif nargout == 1
                
                varargout{1} = Vector(self);
                
                varargout{1}.imag;
                
            else
                
                error('Wrong amount of outputs to Vector imag()!');
                
            end
            
        end       
        
        function varargout = convert_to(self, new_type)
            
            if self.is_vector_type(new_type)
                
                if nargout == 0
                    
                    if ~strcmp(self.type, new_type)
                        
                        if strcmp(new_type, 'cart')
                            
                            if strcmp(self.type, 'cyl')
                                
                                r = self.value(1);
                                
                                phi = self.value(2);
                                
                                self.value(1) = r*cos(phi);
                                
                                self.value(2) = r*sin(phi);
                                
                            elseif strcmp(self.type, 'pol')
                                
                                r = self.value(1);
                                
                                phi = self.value(2);
                                
                                teta = self.value(3);
                                
                                self.value(1) = r*sin(teta)*cos(phi);
                                
                                self.value(2) = r*sin(teta)*sin(phi);
                                
                                self.value(3) = r*cos(teta);
                                
                            end
                            
                        elseif strcmp(new_type, 'cyl')
                            
                            if strcmp(self.type, 'cart')
                                
                                x = self.value(1);
                                
                                y = self.value(2);
                                
                                self.value(1) = (x^2 + y^2)^0.5;
                                
                                self.value(2) = atan(y/x);
                                
                            elseif strcmp(self.type, 'pol')
                                
                                r = self.value(1);
                                
                                phi = self.value(2);
                                
                                teta = self.value(3);
                                
                                self.value(1) = r*sin(teta);
                                
                                self.value(2) = phi;
                                
                                self.value(3) = r*cos(teta);
                                
                            end
                            
                        elseif strcmp(new_type, 'pol')
                            
                            if strcmp(self.type, 'cart')
                                
                                x = self.value(1);
                                
                                y = self.value(2);
                                
                                z = self.value(3);
                                
                                self.value(1) = (x^2 + y^2 + z^2)^0.5;
                                
                                if self.value(1) == 0
                                    
                                    self.value = [0 0 0];
                                    
                                else
                                
                                    if x == 0 && y == 0
                                        
                                        self.value(2) = 0;
                                        
                                    else
                                        
                                        self.value(2) = atan(y/x);
                                        
                                    end

                                    self.value(3) = acos(z / self.value(1));
                                
                                end
                                
                            elseif strcmp(self.type, 'cyl')
                                
                                r = self.value(1);
                                
                                phi = self.value(2);
                                
                                z = self.value(3);
                                
                                self.value(1) = (r^2 + z^2)^0.5;
                                
                                if self.value(1) == 0
                                    
                                    self.value = [0 0 0];
                                    
                                else
                                
                                    self.value(2) = phi;

                                    self.value(3) = acos(z / self.value(1));
                                    
                                end
                                
                            end
                            
                        end
                        
                        self.type = new_type;
                        
                    end
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector(self);
                    
                    varargout{1}.convert_to(new_type);
                    
                else
                    
                    error('Wrong number of outputs in Vector.convert_to()!');
                    
                end                   
                
            else
                
                error('Wrong type in Vector.convert_to()!');
                
            end
            
        end
        
        function varargout = plus(self, other)
            
            if is_Vector(self) && is_Vector(other)
                
                if nargout == 0
                    
                    old_type = self.type;
                    
                    self.convert_to('cart');
            
                    other.convert_to('cart');

                    self.value = self.value + other.value;
                    
                    self.convert_to(old_type);
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector(self);
                    
                    varargout{1} + other;
                    
                else
                    
                    error('Wrong number of outputs to Vector plus() operator!')
                    
                end
                
            else
                
                error('Wrong inputs to Vector plus() operator!');
                
            end
            
        end
        
        function varargout = minus(self, other)
            
            if is_Vector(self) && is_Vector(other)
                
                if nargout == 0
                    
                    old_type = self.type;
                    
                    self.convert_to('cart');
            
                    other.convert_to('cart');

                    self.value = self.value - other.value;
                    
                    self.convert_to(old_type);
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector(self);
                    
                    varargout{1} - other;
                    
                else
                    
                    error('Wrong number of outputs to Vector minus() operator!')
                    
                end
                
            else
                
                error('Wrong inputs to Vector minus() operator!');
                
            end
            
        end
        
        function result = mtimes(self, other)
            
            if is_Vector(self) && is_Vector(other)
                
                self.convert_to('cart');
                
                other.convert_to('cart');
                
                result = sum(self.value .* other.value);
                
            elseif is_Vector(self) && is_double(other) && length(other) == 1
                
                result = Vector(self);
                
                if strcmp(self.type, 'cart')
                    
                    result.value = result.value * other;
                    
                elseif strcmp(self.type, 'cyl')
                    
                    result.value(1) = result.value(1) * other;
                    
                    result.value(3) = result.value(3) * other;
                    
                elseif strcmp(self.type, 'pol')
                    
                    result.value(1) = result.value(1) * other;
                    
                end
                
            else
                
                error('Wrong inputs to Vector mtimes() operator!');
                
            end
            
        end
        
        function result = mrdivide(self, other)
            
            if is_Vector(self) && is_double(other) && length(other) == 1 && other ~= 0
                
                result = Vector(self);
                
                if strcmp(self.type, 'cart')
                    
                    result.value = result.value / other;
                    
                elseif strcmp(self.type, 'cyl')
                    
                    result.value(1) = result.value(1) / other;
                    
                    result.value(3) = result.value(3) / other;
                    
                elseif strcmp(self.type, 'pol')
                    
                    result.value(1) = result.value(1) / other;
                    
                end
                
            else
                
                error('Wrong inputs to Vector mrdivide() operator!');
                
            end
            
        end
        
        function varargout = uminus(self)
            
            if nargout == 0
                
                if strcmp(self.type, 'cart')
                    
                    self.value = -self.value;
                    
                elseif strcmp(self.type, 'cyl')
                    
                    self.value(2) = mod(self.value(2) + pi, 2*pi);
                    
                    self.value(3) = -self.value(3);
                    
                elseif strcmp(self.type, 'pol')
                    
                    self.value(2) = mod(self.value(2) + pi, 2*pi);
                    
                    self.value(3) = pi - self.value(3);
                end
                
            elseif nargout == 1
                
                varargout{1} = Vector(self);
                
                -varargout{1};
                
            else
                
                error('Wrong amount of outputs to Vector uminus() operator!');
                
            end
            
        end
        
        function varargout = and(self, other)
            
            if is_Vector(self) && is_Vector(other)
                
                if nargout == 0
                
                    old_type = self.type;
                    
                    old_value = self.value;

                    self.convert_to('cart');

                    other.convert_to('cart');
                    
                    self.value(1) = old_value(2) * other.value(3) - old_value(3) * other.value(2);
                    
                    self.value(2) = -old_value(1) * other.value(3) + old_value(3) * other.value(1);
                    
                    self.value(3) = old_value(1) * other.value(2) - old_value(2) * other.value(1);
                    
                    self.convert_to(old_type);
                
                elseif nargout == 1
                    
                    varargout{1} = Vector(self);
                    
                    varargout{1} & other;
                    
                else
                    
                    error('Wrong amount of outputs to Vector and() operator!');
                
                end
                
            else
                
                error('Wrong inputs to Vector and() operator!');
                
            end
            
        end
        
        function result = eq(self, other)
            
            if is_Vector(self) && is_Vector(other)
                
                other.convert_to(self.type);
                
                result = (self.value(1) == other.value(1)) *...
                         (self.value(2) == other.value(2)) *...
                         (self.value(3) == other.value(3));
                
            else
                
                error('Wrong inputs to Vector eq() operator!');
                
            end
            
        end

    end
    
    methods (Access = protected)
        
        function result = is_vector_type(self, new_type)
            
            result = strcmp(new_type, 'cart') || strcmp(new_type, 'cyl') || strcmp(new_type, 'pol');
            
        end
        
    end

    methods (Hidden)
        
%         function result = addlistener(varargin)
%             
%             result = addlistener@handle(varargin{:});
%             
%         end
%         
%         function result = findobj(varargin)
%             
%             result = findobj@handle(varargin);
%             
%         end
%         
%         function result = gt(varargin)
%             
%             result = gt@handle(varargin);
%             
%         end
%         
%         function result = lt(varargin)
%             
%             result = lt@handle(varargin);
%             
%         end
%         
%         function result = findprop(varargin)
%             
%             result = findprop@handle(varargin);
%             
%         end
%         
%         function result = ne(varargin)
%             
%             result = ne@handle(varargin);
%             
%         end
%         
%         function result = ge(varargin)
%             
%             result = ge@handle(varargin);
%             
%         end
%         
%         function result = le(varargin)
%             
%             result = le@handle(varargin);
%             
%         end
%         
%         function result = notify(varargin)
%             
%             result = notify@handle(varargin);
%             
%         end
        
    end
    
end