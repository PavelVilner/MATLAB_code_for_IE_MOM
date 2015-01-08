
classdef Function1 < handle
    
    properties (SetAccess = protected, GetAccess = public)
        
        f;
        
    end
    
    methods (Access = public)
        
        function fcn = Function1(f_handle)
            
            if is_function_handle(f_handle) && nargin(f_handle) == 1
                
                f_str = func2str(f_handle);
                
                if strcmp(f_str(1:5),'@(c1)')
                
                    fcn.f = f_handle;
                
                else
                    
                    error('Wrong input to Function1 constructor!');
                    
                end
                
            elseif is_Function1(f_handle)
                
                fcn.f = f_handle.f;
                
            else
                
                error('Wrong input to Function1 constructor!');
                
            end
            
        end
        
        function result = subsref(self, S)
            
            aux_type = {S.type};
            
            if length(aux_type) == 1 && strcmp(aux_type{1}, '()')
                
                if length(self) == 1
                
                    result = self.f(S.subs{:});
                    
                elseif is_index(S.subs{:})
                    
                    result = Function1(self(S.subs{:}));
                    
                end
                
            else
                
                result = builtin('subsref', self, S);
                
            end
            
        end
        
        function result = functions(self)
            
            result = functions(self.f);
            
        end            
        
        function result = abs(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = f_data.function;
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function1(eval(['@(c1)abs(',f_string(6:end),')']));
                       
            else
                
                error('Wrong amount of output arguments to Function1 abs()!');
                
            end
            
        end
        
        function result = exp(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = f_data.function;
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function1(eval(['@(c1)exp(',f_string(6:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function1 exp()!');
                
            end
            
        end
        
        function result = conj(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = f_data.function;
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function1(eval(['@(c1)conj(',f_string(6:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function1 conj()!');
                
            end
            
        end
        
        function result = real(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = f_data.function;
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function1(eval(['@(c1)real(',f_string(6:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function1 real()!');
                
            end
            
        end
        
        function result = imag(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = f_data.function;
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function1(eval(['@(c1)imag(',f_string(6:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function1 imag()!');
                
            end
            
        end
        
        function result = plus(self, other)
            
           if is_Function1(self) && is_Function1(other)
                
                if nargout == 1
                    
                    f_data1 = functions(self.f);
                    
                    f_data2 = functions(other.f);
                                                        
                    [param_names, param_values, f_string1, f_string2] = gen_workspace(f_data1.workspace{1},...
                                                                                      f_data2.workspace{1},...
                                                                                      func2str(self.f),...
                                                                                      func2str(other.f));
                                                                                         
                    for n = 1:length(param_names)
                        
                        aux = param_values{n};
                        
                        eval([param_names{n} , '= aux']);
                        
                    end
                    
                    clear('aux','self','other','f_data1','f_data2', 'n');

                    result = Function1(eval(['@(c1)',f_string1(6:end),' + ',f_string2(6:end)]));
                    
                    if ~isempty(param_names)
                    
                        clear(param_names{:}, 'f_string1', 'f_string2', 'param_names', 'param_values');
                    
                    else
                        
                        clear('f_string1', 'f_string2', 'param_names', 'param_values');
                        
                    end
                    
                else
                    
                    error('Wrong number of outputs to Function1 plus()!');
                    
                end
                
            elseif is_Function1(self) && is_double(other) && length(other) == 1
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = f_data.function;

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list', 'f_data');

                    result = Function3(eval(['@(c1)',f_string(6:end),' + ', num2str(other)]));
                
                else
                    
                    error('Wrong number of outputs to Function1 plus()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function1 plus()!');
                
            end
            
        end
        
        function result = minus(self, other)
            
            if is_Function1(self) && is_Function1(other)
                
                if nargout == 1
                    
                    f_data1 = functions(self.f);
                    
                    f_data2 = functions(other.f);
                
                    f_string1 = f_data1.function;
                    
                    f_string2 = f_data2.function;

                    param_list1 = fields(f_data1.workspace{1});
                    
                    param_list2 = fields(f_data2.workspace{1});

                    for n = 1:length(param_list1)

                        aux = f_data1.workspace{1}.(param_list1{n});

                        eval([param_list1{n}, ' = aux']);

                    end
                    
                    for n = 1:length(param_list2)

                        aux = f_data2.workspace{1}.(param_list2{n});

                        eval([param_list2{n}, ' = aux']);

                    end

                    clear('aux','self','other', 'param_list1','param_list2','f_data1','f_data2');

                    result = Function1(eval(['@(c1)',f_string1(6:end),' - (',f_string2(6:end),')']));
                
                else
                    
                    error('Wrong number of outputs to Function1 minus()!');
                    
                end
                
            elseif is_Function1(self) && is_double(other) && length(other) == 1
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = f_data.function;

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self', 'param_list','f_data');

                    result = Function1(eval(['@(c1)',f_string(6:end),' - other']));
                
                else
                    
                    error('Wrong number of outputs to Function1 minus()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function1 minus()!');
                
            end
            
        end
        
        function result = uminus(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = f_data.function;
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list','f_data');
                                                
                result = Function1(eval(['@(c1)-(',f_string(6:end),')']));
            
            else
                
                error('Wrong amount of outputs to Function1 uminus()!');
                
            end
            
        end
        
        function result = mtimes(self, other)
            
            if is_Function1(self) && is_Function1(other)
                
                if nargout == 1
                    
                    f_data1 = functions(self.f);
                    
                    f_data2 = functions(other.f);
                
                    f_string1 = f_data1.function;
                    
                    f_string2 = f_data2.function;

                    param_list1 = fields(f_data1.workspace{1});
                    
                    param_list2 = fields(f_data2.workspace{1});

                    for n = 1:length(param_list1)

                        aux = f_data1.workspace{1}.(param_list1{n});

                        eval([param_list1{n}, ' = aux']);

                    end
                    
                    for n = 1:length(param_list2)

                        aux = f_data2.workspace{1}.(param_list2{n});

                        eval([param_list2{n}, ' = aux']);

                    end

                    clear('aux','self','other', 'param_list1','param_list2','f_data1','f_data2');

                    result = Function1(eval(['@(c1)(',f_string1(6:end),') * (',f_string2(6:end),')']));
                
                else
                    
                    error('Wrong number of outputs to Function1 mtimes()!');
                    
                end
                
            elseif is_Function1(self) && is_double(other) && length(other) == 1
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = f_data.function;

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list','f_data');

                    result = Function1(eval(['@(c1)(',f_string(6:end),') * other']));
               
                else
                    
                    error('Wrong number of outputs to Function1 mtimes()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function1 mtimes()!');
                
            end
            
        end
        
        function result = mrdivide(self, other)
            
            if is_Function1(self) && is_Function1(other)
                
                if nargout == 1
                    
                    f_data1 = functions(self.f);
                    
                    f_data2 = functions(other.f);
                
                    f_string1 = f_data1.function;
                    
                    f_string2 = f_data2.function;

                    param_list1 = fields(f_data1.workspace{1});
                    
                    param_list2 = fields(f_data2.workspace{1});

                    for n = 1:length(param_list1)

                        aux = f_data1.workspace{1}.(param_list1{n});

                        eval([param_list1{n}, ' = aux']);

                    end
                    
                    for n = 1:length(param_list2)

                        aux = f_data2.workspace{1}.(param_list2{n});

                        eval([param_list2{n}, ' = aux']);

                    end

                    clear('aux','self','other', 'param_list1','param_list2','f_data1','f_data2');

                    result = Function1(eval(['@(c1)(',f_string1(6:end),') / (',f_string2(6:end),')']));
                
                else
                    
                    error('Wrong number of outputs to Function1 mrdivide()!');
                    
                end
                
            elseif is_Function1(self) && is_double(other) && length(other) == 1 && other ~= 0
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = f_data.function;

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list','f_data');

                    result = Function1(eval(['@(c1)(',f_string(6:end),') / other']));
                 
                else
                    
                    error('Wrong number of outputs to Function1 mrdivide()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function1 mrdivide()!');
                
            end
            
        end
        
        function result = mpower(self, other)
            
            if is_Function1(self) && is_Function1(other)
                
                if nargout == 1
                    
                    f_data1 = functions(self.f);
                    
                    f_data2 = functions(other.f);
                
                    f_string1 = f_data1.function;
                    
                    f_string2 = f_data2.function;

                    param_list1 = fields(f_data1.workspace{1});
                    
                    param_list2 = fields(f_data2.workspace{1});

                    for n = 1:length(param_list1)

                        aux = f_data1.workspace{1}.(param_list1{n});

                        eval([param_list1{n}, ' = aux']);

                    end
                    
                    for n = 1:length(param_list2)

                        aux = f_data2.workspace{1}.(param_list2{n});

                        eval([param_list2{n}, ' = aux']);

                    end

                    clear('aux','self','other', 'param_list1','param_list2','f_data1','f_data2');
                    
                    result = Function1(eval(['@(c1)(',f_string1(6:end),') ^ (',f_string2(6:end),')']));
                
                else
                    
                    error('Wrong number of outputs to Function1 mpower()!');
                    
                end
                
            elseif is_Function1(self) && is_double(other) && length(other) == 1
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = f_data.function;

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list','f_data');

                    result = Function1(eval(['@(c1)(',f_string(6:end),') ^ other']));
                
                else
                    
                    error('Wrong number of outputs to Function1 mpower()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function1 mpower()!');
                
            end
            
        end
                
        function result = d1(self, dc1, varargin)
            
            if nargin == 2 && is_double(dc1) && length(dc1) == 1 && dc1 > 0
                
                f_data = functions(self.f);
                
                f_string = f_data.function;
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                aux1 = strrep(f_string(6:end),'c1', 'c1 + dc1');
                
                aux2 = strrep(f_string(6:end),'c1', 'c1 - dc1');
                
                clear('aux','self','param_list','f_data','f_string');
                                                
                result = Function1(eval(['@(c1)(', aux1, ' - ', aux2,')/(2*dc1)']));
            
            elseif nargin == 3 && is_double(varargin{1}) && length(varargin{1}) == 1
                
%                 result = (self.f(varargin{1} + dx) - self.f(varargin{1} - dx))/2/dx;
                
            else
                
                error('Wrong inputs to Function1 d1()!')
                
            end
            
        end
        
    end
    
end