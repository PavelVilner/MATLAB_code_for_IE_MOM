
function result = Integral(Field, c1_min, c2_min, c3_min, c1_max, c2_max, c3_max, N_c1, N_c2, N_c3, type)

if ~is_Scalar_field(Field) && ~is_Vector_field(Field)
   
    error('Wrong integrand parameter in Integral()!');
    
end

if ~strcmp(type, 'cart') && ~strcmp(type, 'cyl') && ~strcmp(type, 'pol')
    
    error('Wrong integration type in Integral()!');
    
end

if c1_min == c1_max && N_c1 ~= 1
    
    error('Wrong integration limits to c1 in Integral()!');
    
elseif N_c1 == 1
    
    c1_arr = c1_min;
    
    dc1 = 1;
    
else
    
    c1_arr = linspace(c1_min, c1_max, N_c1); 
    
    dc1 = c1_arr(2) - c1_arr(1);
    
end

if c2_min == c2_max && N_c2 ~= 1
    
    error('Wrong integration limits to c2 in Integral()!');
    
elseif N_c2 == 1
    
    c2_arr = c2_min;
    
    dc2 = 1;
    
else
    
    c2_arr = linspace(c2_min, c2_max, N_c2); 
    
    dc2 = c2_arr(2) - c2_arr(1);
    
end

if c3_min == c3_max && N_c3 ~= 1
    
    error('Wrong integration limits to c3 in Integral()!');
    
elseif N_c3 == 1
    
    c3_arr = c3_min;
    
    dc3 = 1;
    
else
    
    c3_arr = linspace(c3_min, c3_max, N_c3); 
    
    dc3 = c3_arr(2) - c3_arr(1);
    
end

if is_Scalar_field(Field)
    
    result = 0;
    
else
    
    result = Vector(0,0,0, Field.self_type);
    
end

switch type

    case 'cart'

        for nc1 = 1:N_c1

            for nc2 = 1:N_c2

                for nc3 = 1:Nc3

                    result = result + Field(Coordinate(c1_arr(nc1), c2_arr(nc2), c3_arr(nc3), 'type'))*dc1*dc2*dc3;

                end

            end

        end

    case 'cyl'

        for nc1 = 1:N_c1

            for nc2 = 1:N_c2

                for nc3 = 1:N_c3

                    result = result + Field(Coordinate(c1_arr(nc1), c2_arr(nc2), c3_arr(nc3), type))*c1_arr(nc1)*dc1*dc2*dc3;

                end

            end

        end


    case 'pol'

        for nc1 = 1:N_c1

            for nc2 = 1:N_c2

                for nc3 = 1:Nc3

                    result = result + Field(Coordinate(c1_arr(nc1), c2_arr(nc2), c3_arr(nc3), 'type'))*c1_arr(nc1)^2*sin(c3_arr(nc3))*dc1*dc2*dc3;

                end

            end

        end


end


