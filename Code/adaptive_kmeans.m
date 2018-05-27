function [k, class, img_vect, noOfIter]= adaptive_kmeans(img);

k = 5;
img = double(img);
img = imresize(img, [256,256]);
img_vect = img(:);
centroid = zeros(k,1);
old_centroid = centroid;
class = zeros(length(img_vect), k);
%initialize centroid
maximum = max(img_vect);
for cent = 1:k
    centroid(cent,1)= cent * maximum / k;
end
iter = 1;
noOfIter = 0;
while(iter==1)
    class(1:length(img_vect),1:k) = 0;
    % classifying pixels
    for i = 1: length(img_vect)
        [val, ind]=min(abs(img_vect(i) - centroid((1:k),1)));
        class(i,ind)= img_vect(i);
    end
    
    old_centroid= centroid;
    % updating centroid
    for cent = 1:k
        centroid(cent, 1)= sum(class(:,cent))/length(find(class(:,cent)));
    end
    if(old_centroid == centroid)
        iter = 0;
    end
   noOfIter = noOfIter + 1;
end
fprintf(" noOfIter %d ", noOfIter);
% figure;imshow(img,[]),title('original');
% for clust = 1:k
%     cluster = reshape(class(1:length(img_vect),clust:clust), [256,256] );
%     figure; imshow(cluster,[]),title('cluster');
% end
    
