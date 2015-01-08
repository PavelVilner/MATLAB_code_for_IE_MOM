
function [param_names, param_values, new_f_string1, new_f_string2] = gen_workspace(workspace1, workspace2, f_string1, f_string2)

params1 = fields(workspace1);

params2 = fields(workspace2);

[common_names, common1, common2] = intersect(params1, params2);

result_length = length(params1) + length(params2) - length(common_names);

param_names = [];

param_values = [];

separate1 = invert_indexes(1:length(params1), common1);

separate2 = invert_indexes(1:length(params2), common2);

k = 1;

for n = 1:length(params1)
    
    f_string1 = my_strrep(f_string1, params1{n}, sprintf('aux%d', n));
    
end

for n = 1:length(params2)
    
    f_string2 = my_strrep(f_string2, params2{n}, sprintf('aux%d', n));
    
end

for n = 1:length(params1) - length(common1)
    
%     param_names = [param_names, params1(separate1(n))];

    param_names = [param_names, {sprintf('p%d',k)}];
    
%     f_string1 = my_strrep(f_string1, params1{separate1(n)}, sprintf('p%d',k));

    f_string1 = my_strrep(f_string1, sprintf('aux%d', separate1(n)), sprintf('p%d',k));
    
    k = k+1;
    
    param_values = [param_values, {workspace1.(params1{separate1(n)})}];
   
end

for n = 1:length(params2) - length(common2)
    
%     param_names = [param_names, params2(separate2(n))];

    param_names = [param_names, {sprintf('p%d',k)}];
    
%     f_string2 = my_strrep(f_string2, params2{separate2(n)},  sprintf('p%d',k));

    f_string2 = my_strrep(f_string2, sprintf('aux%d', separate2(n)), sprintf('p%d',k));
    
    k = k+1;
    
    param_values = [param_values, {workspace2.(params2{separate2(n)})}];
    
end

for n = 1:length(common_names)
    
    try
    
        if workspace1.(params1{common1(n)}) == workspace2.(params2{common2(n)})

%             param_names = [param_names, params1(common1(n))];
            
            param_names = [param_names, {sprintf('p%d',k)}];
    
            f_string1 = my_strrep(f_string1, sprintf('aux%d',common1(n)),  sprintf('p%d',k));
            
            f_string2 = my_strrep(f_string2, sprintf('aux%d',common2(n)),  sprintf('p%d',k));
            
            k = k+1;

            param_values = [param_values, {workspace1.(params1{common1(n)})}];

        else

%             param_names = [param_names, {[params1{common1(n)},'1']}, {[params1{common1(n)},'2']}];

            param_names = [param_names, {sprintf('p%d',k)}];
            
            f_string1 = my_strrep(f_string1, sprintf('aux%d',common1(n)), sprintf('p%d',k));

            k = k+1;
            
            

            param_names = [param_names, {sprintf('p%d',k)}];
            
            f_string2 = my_strrep(f_string2, sprintf('aux%d',common2(n)),  sprintf('p%d',k));


            k = k+1;
            
            
            param_values = [param_values, {workspace1.(params1{common1(n)})}, {workspace2.(params1{common2(n)})}];

        end
    
    catch
        
%         param_names = [param_names, {[params1{common1(n)},'1']}, {[params1{common1(n)},'2']}];
% 
%         param_values = [param_values, {workspace1.(params1{common1(n)})}, {workspace2.(params1{common2(n)})}];
% 
%         f_string1 = my_strrep(f_string1, params1{common1(n)}, [params1{common1(n)},'1']);
% 
%         f_string2 = my_strrep(f_string2, params1{common1(n)}, [params1{common1(n)},'2']);

            param_names = [param_names, sprintf('p%d',k)];
            
            f_string1 = my_strrep(f_string1, sprintf('aux%d',common1(n)), [params1{common1(n)},'1']);

            k = k+1;
            
            

            param_names = [param_names, sprintf('p%d',k)];
            
            f_string2 = my_strrep(f_string2, sprintf('aux%d',common2(n)), [params1{common1(n)},'2']);

            k = k+1;
            
            

            param_values = [param_values, {workspace1.(params1{common1(n)})}, {workspace2.(params1{common2(n)})}];
        
    end
    
end

new_f_string1 = f_string1;

new_f_string2 = f_string2;



