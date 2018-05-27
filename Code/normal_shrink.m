
function denoise=normal_shrink(noisy);

noisy = imresize(noisy,[256 256]);   
[r c]=size(noisy);

[cc ss]=wavedec2(noisy,1,'sym8');  
%approximation coeff - low frequency band
approx = appcoef2(cc,ss,'sym8',1);  
% detail coeff in 3 orientation - high frequency bands
dia=detcoef2('d',cc,ss,1);   
[hori,vert,dia] = detcoef2('all',cc,ss,1);

Ns=size(noisy,1)*size(noisy,2);

%T= lambda * sigmaY^2 / sigmaX^2; 
%lambda = sqrt(log (length of subband at each level)/decomposition level))
%Optimal Threshold value is obtained using the estimated noise variance, the
%standard deviation of the sub-band of noisy image, and a parameter .

% noise variance estimate
sigV= median(abs(dia(:)))/0.6745; 
sigY21=sum(hori(:).^2)/Ns;
sigY22=sum(vert(:).^2)/Ns;
sigY23=sum(dia(:).^2)/Ns;
% standard deviation calculation
sigx1=sqrt(max(sigY21-sigV^2,0)); 
sigx2=sqrt(max(sigY22-sigV^2,0));
sigx3=sqrt(max(sigY23-sigV^2,0));


% thresholding parameter 
if sigV^2<sigY21
    th1=sigV^2/sigx1;
else
    th1=max(abs(hori(:)));
end

if sigV^2<sigY22
    th2=sigV^2/sigx2;
else
    th2=max(abs(vert(:)));
end

if sigV^2<sigY23
    th3=sigV^2/sigx3;
else
    th3=max(abs(dia(:)));
end

th1=th1*sqrt(log(Ns));
th2=th2*sqrt(log(Ns));
th3=th3*sqrt(log(Ns));

%soft thresholding
hori_t=wthresh(hori,'s',th1);
vert_t=wthresh(vert,'s',th2);
dia_t=wthresh(dia,'s',th3);


approx_t=approx;

rec=[approx_t(:)' hori_t(:)' vert_t(:)' dia_t(:)'];
denoise=waverec2(rec,ss,'sym8');
denoise=wiener2(denoise);

% figure('NAME','normal-shrink'),imshow(denoise,[]);
jn=double(noisy);
jd=jn(:); fd=denoise(:);
snr1=10*log(sum(jd.^2)/(sum((jd-fd).^2)))/log(10)
psnr1=(10*log((max(jd(:)).^2)/(sum((jd-fd).^2)/(size(denoise,1)*size(denoise,2))))/log(10))