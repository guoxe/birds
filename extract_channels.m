function x = extract_channels(im,channels,feature_size)
%EXTRACT_CHANNELS Extract different channels from the input image im
%(grayscale)
%   Extract various channel features from the image, such as:
%   gradient magnitude, gradients in different directions, min-max filter,
%   grayscale
    size = sqrt(feature_size);
    grayscale = reshape(im, 1, feature_size);
    grayscale = (grayscale-mean(grayscale)) ./ std(grayscale);%perform normalization
    [grad_mag,O] = gradientMag(im,0,0,0,0);
    grad_mag = reshape(grad_mag,1,feature_size);
    %max_min = reshape(rangefilt(reshape(grayscale, size, size)),1,feature_size);
    %entropy = reshape(entropyfilt(reshape(im2double(grayscale), size, size)), 1, feature_size);
    %stdfilter = reshape(stdfilt(reshape(im2double(grayscale), size, size)), 1, feature_size);

    
% Gradients in different directions

    %[Gx,Gy]=gradient2(im);
    %M=sqrt(Gx.^2+Gy.^2);
    %O=atan2(Gy,Gx);
    %full=0;
    %[M1,O1]=gradientMag(im,0,0,0,full);
    %D=abs(M-M1); 
    %mean2(D), if(full), o=pi*2; else o=pi; end;
    %D=abs(O-O1);
    %D(~M)=0;
    %D(D>o*.99)=o-D(D>o*.99);
    %mean2(abs(D));
    %H1=gradientHist(M1,O1,1,6,0);
    %G1 = reshape(H1(:,:,1), 1, feature_size);
    %G2 = reshape(H1(:,:,2), 1, feature_size);
    %G3 = reshape(H1(:,:,3), 1, feature_size);
    %G4 = reshape(H1(:,:,4), 1, feature_size);
    %G5 = reshape(H1(:,:,5), 1, feature_size);
    %G6 = reshape(H1(:,:,6), 1, feature_size);
    x = [grad_mag grayscale];
end

