
function result = invert_indexes(source, indexes)

aux1 = ones(1, length(source));

aux1(indexes) = 0;

result = find(aux1);

