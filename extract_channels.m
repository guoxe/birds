function x = extract_channels(im,channels,feature_size)
%EXTRACT_CHANNELS Extract different channels from the input image im
%(grayscale)
%   Extract various channel features from the image, such as:
%   gradient magnitude, gradients in different directions, min-max filter,
%   grayscale

    size = sqrt(feature_size);
    grayscale = reshape(im, 1, feature_size);
    
    [grad_mag,O] = gradientMag(im,0,0,0,0);
    grad_mag = reshape(grad_mag,1,feature_size);
    %max_min = reshape(rangefilt(reshape(grayscale, size, size)),1,feature_size);
    %entropy = reshape(entropyfilt(reshape(im2double(grayscale), size, size)), 1, feature_size);
    %stdfilter = reshape(stdfilt(reshape(im2double(grayscale), size, size)), 1, feature_size);
    %perform gabor filtering
    orientation = [0 30 60 90 120 150];
    g = gabor(2, orientation);
    outMag = imgaborfilt(im,g);
    outMag = reshape(outMag, [1 feature_size 6]);
    gabor_channels = [outMag(:,:,1) outMag(:,:,2) outMag(:,:,3) outMag(:,:,4) outMag(:,:,5) outMag(:,:,6)];
    x = [grad_mag grayscale gabor_channels];
end

