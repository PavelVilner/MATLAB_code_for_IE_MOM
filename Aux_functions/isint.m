function result = isint(n)

if isdouble(n) && isempty(find(floor(n) ~= n,1))
    
    result = 1;
    
else
    
    result = 0;
    
end    