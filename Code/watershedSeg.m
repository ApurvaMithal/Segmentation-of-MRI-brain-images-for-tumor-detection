function watershedSeg(org, sob55);

subplot(3,3,1), imshow(org,[]), title('original');

%calculate gradient magnitude and use it as segmentaion function
sob55 = sobel55(org);
subplot(3,3,2), imshow(sob55,[]), title('sobel');

%After applying watershed transform on gradient magnitude -- oversegmented
W = watershed(sob55);
Lrgb = label2rgb(W);
subplot(3,3,3), imshow(Lrgb,[]), title('WT on gradient');

%marking the foregroung objects
%morphological operators transform the original image into another image through the iteration 
%with other image of a certain shape and size which is known as structuring element
structureElem = strel('disk', 7);

%opening by reconstruction 
imgErode = imerode(org, structureElem);
imgRecons = imreconstruct(imgErode, org);
%subplot(3,3,2), imshow(imgRecons), title('Open Reconstruction')

%closing by reconstr
imgDilate = imdilate(imgRecons, structureElem);
imgRecons2 = imreconstruct(imcomplement(imgDilate), imcomplement(imgRecons));
imgRecons2 = imcomplement(imgRecons2);
%subplot(3,3,3), imshow(imgRecons2), title('close reconstruction')

%calculate regional maxima
regMaxima = imregionalmax(imgRecons2);
subplot(3,3,4), imshow(regMaxima), title('Region maxima');
org2 = org;
org2(regMaxima) = 255;
subplot(3,3,5),imshow(org2,[]), title('maxima superimposed on original')

%Clean the edges of the markers using edge reconstruction
structureElem2 = strel(ones(5,5));
regMaxima2 = imclose(regMaxima, structureElem2);
regMaxima3 = imerode(regMaxima2, structureElem2);
regMaxima4 = bwareaopen(regMaxima3, 20);
org3 = org;
org3(regMaxima4) = 255;

%Compute background markers
bw = imbinarize(imgRecons2);
subplot(3,3,6), imshow(bw,[]), title('binarized')

%distance transform of binarized
distTrans = bwdist(bw);
distTransW = watershed(distTrans);
bgm = distTransW == 0;
subplot(3,3,7), imshow(bgm,[]), title('background maxima')

%Compute the Watershed Transform of the Segmentation Function
sob2 = imimposemin(sob55, bgm | regMaxima4);
W2 = watershed(sob2);

org4 = org;
org4(imdilate(W2 == 0, ones(3, 3)) | bgm | regMaxima4) = 255;
subplot(3,3,8),imshow(org4,[]), title('Markers/boundaries superimposed on original')
Lrgb2 = label2rgb(W2, 'jet', 'w', 'shuffle');
subplot(3,3,9), imshow(Lrgb2,[]),title('watershed label')

