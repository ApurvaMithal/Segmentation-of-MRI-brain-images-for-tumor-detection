function [ Unew, centroid, obj_func_new ] = fuzzyCMeans( img, k )

[row, col] = size(img);
fuzziness = 2;      % fuzzification parameter
epsilon = 0.001;  % stopping condition
max_iter = 100;   % number of maximun iteration

Uold = rand(row, col, k);
dep_sum = sum(Uold, 3);
dep_sum = repmat(dep_sum, [1,1, k]);
Uold = Uold./dep_sum;

centroid = zeros(k,1); 
for i=1:k
    centroid(i,1) = sum(sum(Uold(:,:,i).*img))/sum(sum(Uold(:,:,i)));
end
obj_func_old = 0;
for i=1:k
    obj_func_old = obj_func_old + sum(sum((Uold(:,:,i) .*img - centroid(i)).^2));
end

for iter = 1:max_iter   
    Unew = zeros(size(Uold));
    for i=1:row
        for j=1:col
            for uII = 1:k
                tmp = 0;
                for uJJ = 1:k
                    disUp = abs(img(i,j) - centroid(uII));
                    disDn = abs(img(i,j) - centroid(uJJ));
                    tmp = tmp + (disUp/disDn).^(2/(fuzziness-1));
                end
                Unew(i,j, uII) = 1/(tmp);
            end            
        end
    end   

    obj_func_new = 0;
    for i=1:k
        obj_func_new = obj_func_new + sum(sum((Unew(:,:,i) .*img - centroid(i)).^2));
    end

    if max(max(max(abs(Unew-Uold))))<epsilon || abs(obj_func_new - obj_func_old)<epsilon 
        break;
    else
        Uold = Unew.^fuzziness;
        for i=1:k
            centroid(i,1) = sum(sum(Uold(:,:,i).*img))/sum(sum(Uold(:,:,i)));
        end
        obj_func_old = obj_func_new;
    end
end