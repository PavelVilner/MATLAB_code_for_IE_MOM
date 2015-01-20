
function result = resolve_singularity(c1, c2, c3, s1, s2, s3, dc1, dc2, dc3, mu, k)

% if abs(c1 - s1) > abs(dc1/2) || abs(c2 - s2) > abs(dc2/2) || abs(c3 - s3) > abs(dc3/2)

if abs(c1 - s1) > (dc1/2) || abs(c2 - s2) > (dc2/2) || abs(c3 - s3) > (dc3/2)

    
    R = sqrt((c1 - s1)^2 + (c2 - s2)^2 + (c3 - s3)^2);
    
    result = mu/4/pi*exp(-1i*k*R)/R;
    
    clear('c1', 'c2', 'c3', 's1', 's2', 's3', 'dc1', 'dc2', 'dc3');
    
else
    
    result = 0;

%     if dc1 == 0
% 
%         result = dc2*dc3;
%         
%     elseif dc2 == 0
%         
%         result = dc1*dc3;
%         
%     elseif dc3 == 0
%         
%         result = dc1*dc2;
%         
%     else
%         
%         result = dc1*dc2*dc3;
%         
%     end
    
end