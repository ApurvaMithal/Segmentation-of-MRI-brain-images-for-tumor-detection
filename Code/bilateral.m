function B=bilateral(ns);
% preserve edges. The intensity value at each pixel in an image is replaced by a
% weighted average of intensity values from nearby pixels

% Start of bilateral filter

% gaussian distance weights
w     = 5;       
sigma = [3 0.1]; 
[X,Y] = meshgrid(-w:w,-w:w);
G = exp(-(X.^2+Y.^2)/(2*sigma(1)^2));

dim = size(ns); 
B = zeros(dim);
for ii = 1:dim(1)
   for jj = 1:dim(2)

         iMin = max(ii-w,1);
         iMax = min(ii+w,dim(1));
         jMin = max(jj-w,1);
         jMax = min(jj+w,dim(2));
         I = ns(iMin:iMax,jMin:jMax);
         H = exp(-(I-ns(ii,jj)).^2/(2*sigma(2)^2));
         F = H.*G((iMin:iMax)-ii+w+1,(jMin:jMax)-jj+w+1);
         B(ii,jj) = sum(F(:).*I(:))/sum(F(:));
   end
end
 % B=B.*255;

% end of bilateral filter