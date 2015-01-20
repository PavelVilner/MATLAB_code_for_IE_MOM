

function result = Green_integral(Green, V_f, resolve,varargin)

if is_G(Green) && is_Vector_field(V_f) && (strcmp(resolve, 'yes') || strcmp(resolve, 'no'))
    
    if nargin == 13
        
        c1_min = varargin{1};
        
        c2_min = varargin{2};
        
        c3_min = varargin{3};
        
        c1_max = varargin{4};
        
        c2_max = varargin{5};
        
        c3_max = varargin{6};
        
        if c1_min == c1_max
            
            dc1 = 1;
            
            c1_N = 1;
            
            c1_arr = c1_min;
            
        else
        
            c1_N = varargin{7};
            
            c1_arr = linspace(c1_min, c1_max, c1_N);
            
            dc1 = c1_arr(2) - c1_arr(1);
            
        end
        
        if c2_min == c2_max
            
            dc2 = 1;
            
            c2_N = 1;
            
            c2_arr = c2_min;
            
        else
        
            c2_N = varargin{8};
            
            c2_arr = linspace(c2_min, c2_max, c2_N);
            
            dc2 = c2_arr(2) - c2_arr(1);
        
        end
        
        if c3_min == c3_max
            
            dc3 = 1;
            
            c3_N = 1;
            
            c3_arr = c3_min;
            
        else
        
            c3_N = varargin{9};
            
            c3_arr = linspace(c3_min, c3_max, c3_N);
            
            dc3 = c3_arr(2) - c3_arr(1);
        
        end
        
        type = varargin{10};
        
        if ~(is_double(c1_min) && is_double(c2_min) && is_double(c3_min) && ...
             isreal(c1_min) && isreal(c2_min) && isreal(c3_min) &&...
             is_double(c1_max) && is_double(c2_max) && is_double(c3_max) &&...
             isreal(c1_max) && isreal(c2_max) && isreal(c3_max) &&...
             is_double(dc1) && is_double(dc2) && is_double(dc3)) &&...
             (strcmp(type, 'cart') || strcmp(type, 'pol') || strcmp(type, 'cyl'))
         
             error('Error in integration limit inputs to Green_integral()!');
    
        end
        
        func1_string = '@(c1,c2,c3)';
        
        func2_string = '@(c1,c2,c3)';
        
        func3_string = '@(c1,c2,c3)';
        
        
        
        for n = 1:length(c1_arr)
            
            for m = 1:length(c2_arr)
                
                for k = 1:length(c3_arr)
                    
                    Current_coordinate = Coordinate(c1_arr(n), c2_arr(m), c3_arr(k), type);
                    
                    Current_coordinate.convert_to('cart');
                    
                    if strcmp(resolve, 'yes')
                        
                        if strcmp(type, 'cart')
                            
                            dx_local = dc1;
                            
                            dy_local = dc2;
                            
                            dz_local = dc3;
                            
                        elseif strcmp(type, 'cyl')
                            
                            if dc1 ~= 1
                            
                                dx_local = abs(cos(c2_arr(m))*dc1 - c1_arr(n)*sin(c2_arr(m))*dc2);

                                dy_local = abs(sin(c2_arr(m))*dc1 + c1_arr(n)*cos(c2_arr(m))*dc2);
                            
                            else
                                
                                dx_local = abs(- c1_arr(n)*sin(c2_arr(m))*dc2);
                            
                                dy_local = abs(c1_arr(n)*cos(c2_arr(m))*dc2);
                                
                            end
                            
                            dz_local = dc3;
                            
                        elseif strcmp(type, 'pol')
                            
                        end
                                                                                                
                        c_ds = [dx_local, dy_local, dz_local];
                        
                        d_max = max(c_ds([c1_N, c2_N, c3_N] ~= 1)); % having non-square dv is illogical
                    
                        green_string = ['resolve_singularity(c1,c2,c3,',...
                                         '(' num2str(Current_coordinate.value(1),25), '),',...
                                         '(' num2str(Current_coordinate.value(2),25), '),',...
                                         '(' num2str(Current_coordinate.value(3),25), '),',...
                                         '(' num2str(d_max,25), '),',...
                                         '(' num2str(d_max,25), '),',...
                                         '(' num2str(d_max,25), '),',...
                                         '(' num2str(Green.mu,25), '),',...
                                         '(' num2str(Green.k,25), ')',...
                                         ')'];
                                            
                    elseif strcmp(resolve, 'no')
                        
                        green_string = ['(',num2str(Green.mu,25),')/4/pi*exp(-1i*(',num2str(Green.k,25),')*sqrt((c1 - (',num2str(Current_coordinate.value(1),25),...
                                        '))^2+(c2 - (',num2str(Current_coordinate.value(2),25),...
                                        '))^2+(c3 - (',num2str(Current_coordinate.value(3),25),'))^2))'...
                                        '/sqrt((c1 - (',num2str(Current_coordinate.value(1),25),...
                                        '))^2+(c2 - (',num2str(Current_coordinate.value(2),25),...
                                        '))^2+(c3 - (',num2str(Current_coordinate.value(3),25),'))^2)'];
                        
                    end
                    
                    if strcmp(type, 'cart')
                        
                        Jacobian = [];
                        
                    elseif strcmp(type, 'cyl')
                        
                        Jacobian = ['(' num2str(c1_arr(n),25) ')*'];
                        
                    elseif strcmp(type, 'pol')
                        
                        Jacobian = ['((' num2str(c1_arr(n),25) ')^2)*sin(' num2str(c3_arr(k),25) ')*'];
                        
                    end
                    
                    current_V = V_f(Coordinate(c1_arr(n), c2_arr(m), c3_arr(k), type));
                                            
                    if current_V.value(1) ~= 0

                        func1_string = [func1_string,' + ' Jacobian '(',num2str(current_V.value(1),25),')*' green_string];


                    end

                    if current_V.value(2) ~= 0

                        func2_string = [func2_string,' + ' Jacobian '(',num2str(current_V.value(2),25),')*' green_string];

                    end

                    if current_V.value(3) ~= 0

                        func3_string = [func3_string,' + ' Jacobian '(',num2str(current_V.value(3),25),')*' green_string];

                    end
                    
                end
                
            end
            
        end
        
        clear('c1_arr', 'c2_arr', 'c3_arr', 'c1_min', 'c2_min', 'c3_min',...
              'c1_max', 'c2_max', 'c3_max', 'current_loc', 'current_V',...
              'Green', 'k', 'm', 'n', 'type', 'V_f', 'varargin');
          
        if strcmp(func1_string, '@(c1,c2,c3)')
            
            func1_string = '@(c1,c2,c3)0';
            
        end
        
        if strcmp(func2_string, '@(c1,c2,c3)')
            
            func2_string = '@(c1,c2,c3)0';
            
        end
        
        if strcmp(func3_string, '@(c1,c2,c3)')
            
            func3_string = '@(c1,c2,c3)0';
            
        end
        
        result = Vector_field(Function3(eval(func1_string))*dc1*dc2*dc3,...
                              Function3(eval(func2_string))*dc1*dc2*dc3,...
                              Function3(eval(func3_string))*dc1*dc2*dc3, 'cart');
        
        
    elseif nargin == 4
        
    else
        
        error('Wrong amount of inputs to Green_integral()!');
        
    end
    
else
    
    error('Wrong inputs to Green_integral()!');
    
end

