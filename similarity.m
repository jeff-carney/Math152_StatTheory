function nearest10 = similarity(x)

length = size(x, 1);

simMatrix = zeros(length, length);
nearest10 = zeros(length, 10);

for i = 1:length
    for j = 1:length
        if (i == j)
            simMatrix(i, j) = 0;
        else
            dif = x(i,:) - x(j,:);
            norm = dif*dif';
            simMatrix(i,j) = norm;
        end
    end
end


for i = 1:length
     dists = simMatrix(i,:);
     
     dists = sort(dists, 2);
     first10 = dists(2:11);
     [intersectSet, indexFirst10, indexSortMat] = intersect(first10,simMatrix(i,:));
     
     nearest10(i,:) = indexSortMat';
     
     
 
end


end
            
        