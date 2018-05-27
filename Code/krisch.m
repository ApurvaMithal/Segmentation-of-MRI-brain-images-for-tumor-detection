
function img=krisch(i);

% Kirsch comapss masks edges detected in 8 directions

i=imresize(i,[256 256]);
% figure, imshow(i,[])
[r c]=size(i);
e=zeros(r+2,c+2);
for m=2:r+1
    for n=2:c+1
        e(m,n)=i(m-1,n-1);
        
    end
end
% figure, imshow(e,[])
no=zeros(r,c);
nw=zeros(r,c);
w=zeros(r,c);
sw=zeros(r,c);
s=zeros(r,c);
se=zeros(r,c);
ea=zeros(r,c);
ne=zeros(r,c);
for m=2:r+1
    for n=2:c+1
        no(m-1,n-1)=(e(m-1,n-1)*-3)+(e(m-1,n)*-3)+(e(m-1,n+1)*5)+(e(m,n-1)*-3)+(e(m,n)*0)+(e(m,n+1)*5)+(e(m+1,n-1)*-3)+(e(m+1,n)*-3)+(e(m+1,n+1)*5);
        nw(m-1,n-1)=(e(m-1,n-1)*-3)+(e(m-1,n)*5)+(e(m-1,n+1)*5)+(e(m,n-1)*-3)+(e(m,n)*0)+(e(m,n+1)*5)+(e(m+1,n-1)*-3)+(e(m+1,n)*-3)+(e(m+1,n+1)*-3);
        w(m-1,n-1)=(e(m-1,n-1)*5)+(e(m-1,n)*5)+(e(m-1,n+1)*5)+(e(m,n-1)*-3)+(e(m,n)*0)+(e(m,n+1)*-3)+(e(m+1,n-1)*-3)+(e(m+1,n)*-3)+(e(m+1,n+1)*-3);
        sw(m-1,n-1)=(e(m-1,n-1)*5)+(e(m-1,n)*5)+(e(m-1,n+1)*-3)+(e(m,n-1)*5)+(e(m,n)*0)+(e(m,n+1)*-3)+(e(m+1,n-1)*-3)+(e(m+1,n)*-3)+(e(m+1,n+1)*-3);
        s(m-1,n-1)=(e(m-1,n-1)*5)+(e(m-1,n)*-3)+(e(m-1,n+1)*-3)+(e(m,n-1)*5)+(e(m,n)*0)+(e(m,n+1)*-3)+(e(m+1,n-1)*5)+(e(m+1,n)*-3)+(e(m+1,n+1)*-3);
        se(m-1,n-1)=(e(m-1,n-1)*-3)+(e(m-1,n)*-3)+(e(m-1,n+1)*-3)+(e(m,n-1)*5)+(e(m,n)*0)+(e(m,n+1)*-3)+(e(m+1,n-1)*5)+(e(m+1,n)*5)+(e(m+1,n+1)*-3);
        ea(m-1,n-1)=(e(m-1,n-1)*-3)+(e(m-1,n)*-3)+(e(m-1,n+1)*-3)+(e(m,n-1)*-3)+(e(m,n)*0)+(e(m,n+1)*-3)+(e(m+1,n-1)*5)+(e(m+1,n)*5)+(e(m+1,n+1)*5);
        ne(m-1,n-1)=(e(m-1,n-1)*-3)+(e(m-1,n)*-3)+(e(m-1,n+1)*-3)+(e(m,n-1)*-3)+(e(m,n)*0)+(e(m,n+1)*5)+(e(m+1,n-1)*-3)+(e(m+1,n)*5)+(e(m+1,n+1)*5);
    end
end

img=double((no.^2 + nw.^2+ w.^2+ sw.^2+ s.^2+ se.^2+ ea.^2+ ne.^2).^(0.5));

