function ostu_img=ostu(B);

%Image contains 2 classes of pixels, foreground and background pixels.
%Calculate optimal threshold such that inter-class variance is maximum
B = imresize(B, [256, 256]);
[r,c] = size(B);
  
 % Calculation of the normalized histogram
    n = 256;
    h = hist(B(:), n);        
    h = h/(length(B(:))+1);
    
    % Calculation of the cumulated histogram and the mean values
    cumSum = cumsum(h);
    mu = zeros(n, 1); 
    mu(1) = h(1);
    for i=2:n
        mu(i) = mu(i-1) + i*h(i);
    end    
         
    % Initialisation of the values used for the threshold calculation
    w0 = cumSum(1);
    w1 = 1-w0;
    mu0 = mu(1)/w0;
    mu1 = (mu(end)-mu(1))/w1;
    max = w0*w1*(mu1-mu0)*(mu1-mu0);
    lev = 1;
    
    for i = 2:n
        w0 = cumSum(i);
        w1 = 1-w0;
        mu0 = mu(i)/w0;
        mu1 = (mu(end)-mu(i))/w1;
        s = w0*w1*(mu1-mu0)*(mu1-mu0);
        if (s > max)
            max = s;
            lev = i;
        end
    end
    
    % Normalisation of the threshold        
    lev = lev/n;
    ostu_img = imbinarize(uint8(B),lev);
