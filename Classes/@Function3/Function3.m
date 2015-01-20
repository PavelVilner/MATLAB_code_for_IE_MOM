
classdef Function3 < handle
    
    properties (SetAccess = protected, GetAccess = public)
        
        f;
        
    end
    
    methods (Access = public)
        
        function fcn = Function3(f_handle)
            
            if is_function_handle(f_handle) && nargin(f_handle) == 3
                
                f_str = func2str(f_handle);
                
                if strcmp(f_str(1:11),'@(c1,c2,c3)')
                
                    fcn.f = f_handle;
                
                else
                    
                    error('Wrong input to Function3 constructor!');
                    
                end
                
            elseif is_Function3(f_handle)
                
                fcn.f = f_handle.f;
                
            else
                
                error('Wrong input to Function3 constructor!');
                
            end
            
        end
        
        function result = subsref(self, S)
            
            aux_type = {S.type};
            
            if length(aux_type) == 1 && strcmp(aux_type{1}, '()')
                
                if length(self) == 1
                
                    result = self.f(S.subs{:});
                    
                elseif is_index(S.subs{:})
                    
                    result = Function3(self(S.subs{:}));
                    
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
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)abs(',f_string(12:end),')']));
                       
            else
                
                error('Wrong amount of output arguments to Function3 abs()!');
                
            end
            
        end
        
        function result = exp(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)exp(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 exp()!');
                
            end
            
        end
        
        function result = conj(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)conj(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 conj()!');
                
            end
            
        end
        
        function result = real(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)real(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 real()!');
                
            end
            
        end
        
        function result = imag(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)imag(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 imag()!');
                
            end
            
        end
        
        function result = sin(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)sin(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 sin()!');
                
            end
            
        end
        
        function result = cos(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)cos(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 cos()!');
                
            end
            
        end
        
        function result = tan(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)tan(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 tan()!');
                
            end
            
        end
        
        function result = sqrt(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)sqrt(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 sqrt()!');
                
            end
            
        end
        
        function result = asin(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)asin(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 asin()!');
                
            end
            
        end
        
        function result = acos(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)acos(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 acos()!');
                
            end
            
        end
        
        function result = atan(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)atan(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 atan()!');
                
            end
            
        end
        
        function result = log(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)log(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 log()!');
                
            end
            
        end
        
        function result = log10(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list', 'f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)log10(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of output arguments to Function3 log10()!');
                
            end
            
        end
        
        function result = plus(self, other)
            
            if is_Function3(self) && is_Function3(other)
                
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

                    result = Function3(eval(['@(c1,c2,c3)',f_string1(12:end),' + ',f_string2(12:end)]));
                    
                    if ~isempty(param_names)
                    
                        clear(param_names{:}, 'f_string1', 'f_string2', 'param_names', 'param_values');
                        
                    else
                        
                        clear('f_string1', 'f_string2', 'param_names', 'param_values');
                        
                    end
                    
                else
                    
                    error('Wrong number of outputs to Function3 plus()!');
                    
                end
                
            elseif is_Function3(self) && is_double(other) && length(other) == 1
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = f_data.function;

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list', 'f_data');
                    
                    if other ~= 0

                        result = Function3(eval(['@(c1,c2,c3)',f_string(12:end),' + ', num2str(other,25)]));
                    
                    end
                
                else
                    
                    error('Wrong number of outputs to Function3 plus()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function3 plus()!');
                
            end
            
        end
        
        function result = minus(self, other)
            
            if is_Function3(self) && is_Function3(other)
                
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

                    result = Function3(eval(['@(c1,c2,c3)',f_string1(12:end),' - (',f_string2(12:end),')']));
                    
                    if ~isempty(param_names)
                    
                        clear(param_names{:}, 'f_string1', 'f_string2', 'param_names', 'param_values');
                        
                    else
                        
                        clear('f_string1', 'f_string2', 'param_names', 'param_values');
                        
                    end
                    
                else
                    
                    error('Wrong number of outputs to Function3 minus()!');
                    
                end
                
            elseif is_Function3(self) && is_double(other) && length(other) == 1
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = f_data.function;

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list', 'f_data');
                    
                    if other ~= 0

                        result = Function3(eval(['@(c1,c2,c3)',f_string(12:end),' - (', num2str(other,25),')']));
                    
                    end
                
                else
                    
                    error('Wrong number of outputs to Function3 minus()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function3 minus()!');
                
            end
            
        end
        
        function result = uminus(self)
            
            if nargout == 1
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                clear('aux','self','param_list','f_data');
                                                
                result = Function3(eval(['@(c1,c2,c3)-(',f_string(12:end),')']));
            
            else
                
                error('Wrong amount of outputs to Function3 uminus()!');
                
            end
            
        end
        
        function result = mtimes(self, other)
            
            if is_Function3(self) && is_Function3(other)
                
                if nargout == 1
                    
                    f_data1 = functions(self.f);
                    
                    f_data2 = functions(other.f);
                
                    f_string1 = func2str(self.f);
                    
                    f_string2 = func2str(other.f);

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

                    result = Function3(eval(['@(c1,c2,c3)(',f_string1(12:end),') * (',f_string2(12:end),')']));
                
                else
                    
                    error('Wrong number of outputs to Function3 mtimes()!');
                    
                end
                
            elseif is_Function3(self) && is_double(other) && length(other) == 1
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = func2str(self.f);

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list','f_data');

                    if other == 0 || strcmp(f_string(12:end), '0')

                        result = Function3(eval('@(c1,c2,c3)0'));

                    else

                        result = Function3(eval(['@(c1,c2,c3)(',f_string(12:end),') * (', num2str(other,25),')']));

                    end
               
                else
                    
                    error('Wrong number of outputs to Function3 mtimes()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function3 mtimes()!');
                
            end
            
        end
        
        function result = mrdivide(self, other)
            
            if is_Function3(self) && is_Function3(other)
                
                if nargout == 1
                    
                    f_data1 = functions(self.f);
                    
                    f_data2 = functions(other.f);
                
                    f_string1 = func2str(self.f);
                    
                    f_string2 = func2str(other.f);

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

                    result = Function3(eval(['@(c1,c2,c3)(',f_string1(12:end),') / (',f_string2(12:end),')']));
                
                else
                    
                    error('Wrong number of outputs to Function3 mrdivide()!');
                    
                end
                
            elseif is_Function3(self) && is_double(other) && length(other) == 1 && other ~= 0
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = func2str(self.f);

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list','f_data');

                    result = Function3(eval(['@(c1,c2,c3)(',f_string(12:end),') / (', num2str(other,25),')']));
                 
                else
                    
                    error('Wrong number of outputs to Function3 mrdivide()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function3 mrdivide()!');
                
            end
            
        end
        
        function result = mpower(self, other)
            
            if is_Function3(self) && is_Function3(other)
                
                if nargout == 1
                    
                    f_data1 = functions(self.f);
                    
                    f_data2 = functions(other.f);
                
                    f_string1 = func2str(self.f);
                    
                    f_string2 = func2str(other.f);

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
                    
                    result = Function3(eval(['@(c1,c2,c3)(',f_string1(12:end),') ^ (',f_string2(12:end),')']));
                
                else
                    
                    error('Wrong number of outputs to Function3 mpower()!');
                    
                end
                
            elseif is_Function3(self) && is_double(other) && length(other) == 1
                
                if nargout == 1
                
                    f_data = functions(self.f);

                    f_string = func2str(self.f);

                    param_list = fields(f_data.workspace{1});

                    for n = 1:length(param_list)

                        aux = f_data.workspace{1}.(param_list{n});

                        eval([param_list{n}, ' = aux']);

                    end

                    clear('aux','self','param_list','f_data');

                    result = Function3(eval(['@(c1,c2,c3)(',f_string(12:end),') ^ (', num2str(other,25),')']));
                
                else
                    
                    error('Wrong number of outputs to Function3 mpower()!');
                    
                end
                
            else
                
                error('Wrong inputs to Function3 mpower()!');
                
            end
            
        end
                
        function result = d1(self, dc1, varargin)
            
            if nargin == 2 && is_double(dc1) && length(dc1) == 1 && dc1 > 0
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                aux1 = strrep(f_string(12:end),'c1', ['(c1 + ', num2str(dc1,25), ')']);
                
                aux2 = strrep(f_string(12:end),'c1', ['(c1 - ', num2str(dc1,25), ')']);
                
                clear('aux','self','f_data','f_string');
                                                
                result = Function3(eval(['@(c1,c2,c3)(', aux1, ' - (', aux2,'))/(2*', num2str(dc1,25) ,')']));
                
                clear(param_list{:}, 'param_list');
            
            elseif nargin == 3 && is_double(varargin{1}) && length(varargin{1}) == 1
                
%                 result = (self.f(varargin{1} + dx) - self.f(varargin{1} - dx))/2/dx;
                
            else
                
                error('Wrong inputs to Function3 d1()!')
                
            end
            
        end
        
        function result = d2(self, dc2, varargin)
            
            if nargin == 2 && is_double(dc2) && length(dc2) == 1 && dc2 > 0
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                aux1 = strrep(f_string(12:end),'c2', ['(c2 + ', num2str(dc2,25),')']);
                
                aux2 = strrep(f_string(12:end),'c2', ['(c2 - ', num2str(dc2,25),')']);
                
                clear('aux','self','f_data','f_string');
                                                
                result = Function3(eval(['@(c1,c2,c3)(', aux1, ' - (', aux2,'))/(2*', num2str(dc2,25), ')']));
                
                clear(param_list{:}, 'param_list');
            
            elseif nargin == 3 && is_double(varargin{1}) && length(varargin{1}) == 1
                
%                 result = (self.f(varargin{1} + dx) - self.f(varargin{1} - dx))/2/dx;
                
            else
                
                error('Wrong inputs to Function3 d2()!')
                
            end
            
        end
        
        function result = d3(self, dc3, varargin)
            
            if nargin == 2 && is_double(dc3) && length(dc3) == 1 && dc3 > 0
                
                f_data = functions(self.f);
                
                f_string = func2str(self.f);
                
                param_list = fields(f_data.workspace{1});
                
                for n = 1:length(param_list)
                    
                    aux = f_data.workspace{1}.(param_list{n});
                    
                    eval([param_list{n}, ' = aux']);
                    
                end
                
                aux1 = strrep(f_string(12:end),'c3', ['(c3 + ', num2str(dc3,25),')']);
                
                aux2 = strrep(f_string(12:end),'c3', ['(c3 - ', num2str(dc3,25),')']);
                
                clear('aux','self','f_data','f_string');
                                                
                result = Function3(eval(['@(c1,c2,c3)(', aux1, ' - (', aux2,'))/(2*', num2str(dc3,25),')']));
                
                clear(param_list{:}, 'param_list');
            
            elseif nargin == 3 && is_double(varargin{1}) && length(varargin{1}) == 1
                
%                 result = (self.f(varargin{1} + dx) - self.f(varargin{1} - dx))/2/dx;
                
            else
                
                error('Wrong inputs to Function3 d3()!')
                
            end
            
        end
        
    end
    
end