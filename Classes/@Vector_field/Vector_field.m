
classdef Vector_field < handle
    
    properties(SetAccess = protected, GetAccess = public)
        
        gen_func1;
        
        gen_func2;
        
        gen_func3;
        
        in_type;
        
        self_type;
        
    end
    
    methods (Access = public)
        
        function Vctr_f = Vector_field(varargin)
            
            if nargin == 1 && is_Vector_field(varargin{1})
                
                Vctr_f.gen_func1 = varargin{1}.gen_func1;
                
                Vctr_f.gen_func2 = varargin{1}.gen_func2;
                
                Vctr_f.gen_func3 = varargin{1}.gen_func3;
                
                Vctr_f.in_type = varargin{1}.in_type;
                
                Vctr_f.self_type = varargin{1}.self_type;
            
            elseif nargin == 4 &&...
                   is_Function3(varargin{1}) &&...
                   is_Function3(varargin{2}) &&...
                   is_Function3(varargin{3}) &&...
                   is_Vector_type(varargin{4})
           
                Vctr_f.gen_func1 = varargin{1};
                
                Vctr_f.gen_func2 = varargin{2};
                
                Vctr_f.gen_func3 = varargin{3};
                
                Vctr_f.in_type = varargin{4};
                
                Vctr_f.self_type = varargin{4};
                
            elseif nargin == 5 &&...
                   is_Function3(varargin{1}) &&...
                   is_Function3(varargin{2}) &&...
                   is_Function3(varargin{3}) &&...
                   is_Vector_type(varargin{4}) &&...
                   is_Vector_type(varargin{5})
           
                Vctr_f.gen_func1 = varargin{1};
                
                Vctr_f.gen_func2 = varargin{2};
                
                Vctr_f.gen_func3 = varargin{3};
                
                Vctr_f.in_type = varargin{4};
                
                Vctr_f.self_type = varargin{5};
           
            else
                
                error('Wrong inputs to Vector_field constructor()!');
                
            end
        
        end
        
        function result = subsref(self, S)
            
            aux_type = {S.type};
            
            if length(aux_type) == 1 && strcmp(aux_type{:}, '()')
                
                if is_Coordinate(S.subs{:})
                    
                    S.subs{:}.convert_to(self.in_type);
                
                    result = Vector(self.gen_func1(S.subs{:}.value(1), S.subs{:}.value(2), S.subs{:}.value(3)),...
                                    self.gen_func2(S.subs{:}.value(1), S.subs{:}.value(2), S.subs{:}.value(3)),...
                                    self.gen_func3(S.subs{:}.value(1), S.subs{:}.value(2), S.subs{:}.value(3)),...
                                    self.in_type);
                    
                else
                    
                    error('Wrong input to Vector_field subsref()!');
                    
                end
                
            else
                
                result = builtin('subsref', self, S);
                
            end
            
        end
        
        function convert_to(self, new_type)
            
            if ~is_Vector_type(new_type)
			
				error('Wrong input to Vector_field convert_to()!');
			
            end
			
			if ~strcmp(self.self_type, new_type)
			
				aux1 = self.gen_func1;
				
				aux2 = self.gen_func2;
				
				aux3 = self.gen_func3;
			
				if strcmp(new_type, 'cart')
				
					if strcmp(self.self_type, 'cyl')
					
						
					
					elseif strcmp(self.self_type, 'pol')
					
						
					end
				
				elseif strcmp(new_type, 'cyl')
				
					if strcmp(self.self_type, 'cart')
					
						self.gen_func1 = sqrt(aux1^2 + aux2^2);
						
						self.gen_func2 = atan(aux2 / aux1);
						
						self.gen_func3 = aux3;
					
					elseif strcmp(self.self_type, 'pol')
					
						
					
					end
				
				elseif strcmp(new_type, 'pol')
				
					if strcmp(self.self_type, 'cart')
					
						self.gen_func1 = sqrt(aux1^2 + aux2^2 + aux3^2);
						
						self.gen_func2 = atan(aux2 / aux1);
						
						self.gen_func3 = acos(aux3 / sqrt(aux1^2 + aux2^2 + aux3^2));
					
					elseif strcmp(self.self_type, 'cyl')
					
						
					
					end
				
				end
			
			end
            
        end
        
        function varargout = plus(self, other)
            
            if is_Vector_field(self) && is_Vector_field(other)
                
                if nargout == 0
                    
                    if strcmp(self.self_type, 'cart') && strcmp(other.self_type, 'cart')
                        
                        other.convert_to('cart');
                    
                        aux1 = self.gen_func1;

                        aux2 = self.gen_func2;

                        aux3 = self.gen_func3;

                        self.gen_func1 = aux1 + other.gen_func1;

                        self.gen_func2 = aux2 + other.gen_func2;

                        self.gen_func3 = aux3 + other.gen_func3;
                    
                    else
                        
                        error('Vector_field plus(): Only operations on cartezian fiels are currently supported!');
                        
                    end
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector_field(self);
                    
                    varargout{1} + other;                    
                    
                else
                    
                    error('Wrong amount of outputs to Vector_field plus()!');
                    
                end
            
            elseif is_Vector_field(self) && isdouble(other) && length(other) == 1
                
                if nargout == 0
                    
                    aux1 = self.gen_func1;
                    
                    aux2 = self.gen_func1;
                    
                    aux3 = self.gen_func1;
                    
                    self.gen_func1 = aux1 + other;
                    
                    self.gen_func2 = aux2 + other;
                    
                    self.gen_func3 = aux3 + other;
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector_field(self);
                    
                    varargout{1} + other;                    
                    
                else
                    
                    error('Wrong amount of outputs to Vector_field plus()!');
                    
                end
                
            else
                
                error('Wrong inputs to Vector_field plus()!');
                
            end
            
        end        
        
        function varargout = minus(self, other)
            
            if is_Vector_field(self) && is_Vector_field(other)
                
                if nargout == 0
                    
                    if strcmp(self.self_type, 'cart') && strcmp(other.self_type, 'cart')
                    
                        aux1 = self.gen_func1;

                        aux2 = self.gen_func2;

                        aux3 = self.gen_func3;

                        self.gen_func1 = aux1 - other.gen_func1;

                        self.gen_func2 = aux2 - other.gen_func2;

                        self.gen_func3 = aux3 - other.gen_func3;
                    
                    else
                        
                        error('Vector_field minus(): Only operations on cartezian fiels are currently supported!');
                        
                    end
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector_field(self);
                    
                    varargout{1} - other;                    
                    
                else
                    
                    error('Wrong amount of outputs to Vector_field minus()!');
                    
                end
            
            elseif is_Vector_field(self) && isdouble(other) && length(other) == 1
                
                if nargout == 0
                    
                    aux1 = self.gen_func1;
                    
                    aux2 = self.gen_func1;
                    
                    aux3 = self.gen_func1;
                    
                    self.gen_func1 = aux1 - other;
                    
                    self.gen_func2 = aux2 - other;
                    
                    self.gen_func3 = aux3 - other;
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector_field(self);
                    
                    varargout{1} - other;                    
                    
                else
                    
                    error('Wrong amount of outputs to Vector_field minus()!');
                    
                end
                
            else
                
                error('Wrong inputs to Vector_field minus()!');
                
            end
            
        end
        
        function varargout = mrdivide(self, other)
            
            if is_Vector_field(self) && is_double(other) && length(other) == 1 && other ~= 0
                
                if nargout == 0
                    
                    aux1 = self.gen_func1;
                    
                    aux2 = self.gen_func2;
                    
                    aux3 = self.gen_func3;
                    
                    self.gen_func1 = aux1 / other;
                    
                    self.gen_func2 = aux2 / other;
                    
                    self.gen_func3 = aux3 / other;
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector_field(self);
                    
                    varargout{1} / other;                    
                    
                else
                    
                    error('Wrong amount of outputs to Vector_field mrdivide()!');
                    
                end
                
            else
                
                error('Wrong inputs to Vector_field mrdivide()!');
                
            end
            
        end
        
        function varargout = mtimes(self, other)
            
            if is_Vector_field(self) && is_Vector_field(other)
                
                if strcmp(self.self_type, 'cart') && strcmp(other.self_type, 'cart')
                
                    varargout{1} = Scalar_field(self.gen_func1*other.gen_func1 +...
                                                self.gen_func2*other.gen_func2 +...
                                                self.gen_func3*other.gen_func3, self.in_type);
                                        
                else
                    
                    error('Vector_field mtimes(): Only operations on cartezian fiels are currently supported!');
                    
                end
                
            elseif is_Vector_field(self) && is_double(other) && length(other) == 1
                
                if nargout == 0
                    
                    self.gen_func1 = self.gen_func1 * other;
                    
                    self.gen_func2 = self.gen_func2 * other;
                    
                    self.gen_func3 = self.gen_func3 * other;
                    
                elseif nargout == 1
                    
                    varargout{1} = Vector_field(self);
                    
                    varargout{1} * other;
                    
                else
                    
                    error('Wrong amount of outputs to Vector_field mtimes()!');
                    
                end
                
            else
                
                error('Wrong inputs to Vector_field mtimes()!');
                
            end
            
        end
        
        function varargout = and(self, other)
            
            if is_Vector_field(self) && is_Vector_field(other) && strcmp(self.in_type, other.in_type)
            
                if nargout == 0
                    
                    if strcmp(self.self_type, 'cart') && strcmp(other.self_type, 'cart')

                        aux_f1 = Function3(self.gen_func1);

                        aux_f2 = Function3(self.gen_func2);

                        aux_f3 = Function3(self.gen_func3);

                        self.gen_func1 = aux_f2*other.gen_func3 - aux_f3*other.gen_func2;

                        self.gen_func2 = -aux_f1*other.gen_func3 + aux_f3*other.gen_func1;

                        self.gen_func3 = aux_f1*other.gen_func2 - aux_f2*other.gen_func1;
                    
                    else
                        
                        error('Vector_field and(): Only operations on cartezian fiels are currently supported!');
                        
                    end

                elseif nargout == 1

                    varargout{1} = Vector_field(self);

                    varargout{1} & other;

                else

                    error('Wrong amount of outputs to Vector field and()!');

                end
            
            else
                
                error('Wrong inputs to Vector field and()!');
                
            end
            
        end
        
        function result = abs(self)
            
            aux1 = self.gen_func1;
            
            aux2 = self.gen_func2;
            
            aux3 = self.gen_func3;
            
            result = Scalar_field((aux1^2 + aux2^2 + aux3^3)^0.5, self.in_type);
                                 
        end
        
        function varargout = uminus(self)
            
            if nargout == 0
                
                aux1 = -self.gen_func1;
            
                aux2 = -self.gen_func2;
            
                aux3 = -self.gen_func3;
                
                self.gen_func1 = aux1;
                
                self.gen_func2 = aux2;
                
                self.gen_func3 = aux3;
                
            elseif nargout == 1
                
                varargout{1} = Vector_field(self);
                
                -varargout{1};
                
            else
                
                error('Wrong amount of outputs to Vector_field uminus()!');
                
            end
                                 
        end
                        
        function result = Div(self, dc1, dc2, dc3, varargin)
            
            if nargin == 4
                
                if is_proper_d(dc1) && is_proper_d(dc2) && is_proper_d(dc3)

                    if strcmp(self.in_type, 'cart')

                        result = Scalar_field(self.gen_func1.d1(dc1) +...
                                              self.gen_func2.d2(dc2) +...
                                              self.gen_func3.d3(dc3), self.in_type);

                    elseif strcmp(self.in_type, 'cyl')

                        r = Function3(@(c1,c2,c3)c1);

                        aux1 = self.gen_func1 * r;

                        result = Scalar_field(aux1.d1(dc1) / r +...
                                              (self.gen_func2.d2(dc2))/r +...
                                              self.gen_func3.d3(dc3), self.in_type);

                    elseif strcmp(self.in_type, 'pol')

                        r = Function3(@(c1,c2,c3)c1);

                        sin_t = Function3(@(c1,c2,c3)sin(c3));

                        aux1 = self.gen_func1 * (r^2);

                        aux3 = self.gen_func3 * sin_t;

                        result = Scalar_field(aux1.d1(dc1) / (r^2) +...
                                              self.gen_func2.d2(dc2) / r / sin_t +...
                                              aux3.d3(dc3) / r / sin_t, self.in_type);

                    end
                
                else
                    
                    error('Wrong inputs to Vector_field Div()!');
                    
                end
            
            elseif nargin == 5
                
            else
                
                error('Wrong number of input arguments to Vector_field Div()!');
                
            end
            
        end
        
        function result = Curl(self, dc1, dc2, dc3, varargin)
            
            if nargin == 4
                
                if is_proper_d(dc1) && is_proper_d(dc2) && is_proper_d(dc3)
                                        
                    if strcmp(self.in_type, 'cart')
                        
                        aux1 = self.gen_func3.d2(dc2) - self.gen_func2.d3(dc3);
                        
                        aux2 = -self.gen_func3.d1(dc1) + self.gen_func1.d3(dc3);
                        
                        aux3 = self.gen_func2.d1(dc1) - self.gen_func1.d2(dc2);
                        
                        result = Vector_field(aux1, aux2,aux3,self.in_type);
                        
                    elseif strcmp(self.in_type, 'cyl')
                        
                        r = Function3(@(c1,c2,c3)c1);
                        
                        aux0 = self.gen_func1 * r;
                        
                        aux1 = self.gen_func3.d2(dc2) / r - self.gen_func2.d3(dc3);
                        
                        aux2 = self.gen_func1.d3(dc3) - self.gen_func3.d1(dc1);
                        
                        aux3 = (aux0.d1(dc1)- self.gen_func1.d2(dc2)) / r;
                        
                        result = Vector_field(aux1, aux2,aux3,self.in_type);
                        
                    elseif strcmp(self.in_type, 'pol')
                        
                        r = Function3(@(c1,c2,c3)c1);
                        
                        sin_t = Function3(@(c1,c2,c3)sin(c3));
                        
                        aux_phi_teta = self.gen_func2 * sin_t;
                        
                        aux_phi_r = self.gen_func2 * r;
                        
                        aux_teta_r = r * self.gen_func3;
                        
                        aux1 = (aux_phi_teta.d3(dc3)- self.gen_func3.d2(dc2)) / r / sin_t;
                        
                        aux2 = (aux_teta_r.d1(dc1) - self.gen_func1.d3(dc3)) / r;
                        
                        aux3 = (self.gen_func1.d2(dc2) / sin_t - aux_phi_r.d1(dc1)) / r;
                        
                        result = Vector_field(aux1, aux2,aux3,self.in_type);
                        
                    end
                    
                else
                    
                    error('Wrong arguments to Vector_field Curl()!');
                    
                end
                
            elseif nargin == 5
                
            else
                
                error('Wrong amount of arguments to Vector field Curl()!');
                
            end
            
        end
        
    end
    
end