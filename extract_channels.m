function x = extract_channels(grad,grayscale,gabor1, gabor2, gabor3, gabor4,channels,feature_size, i, j, offset)
%EXTRACT_CHANNELS Extract different channels from the input image im
%(grayscale)
%   Extract various channel features from the image, such as:
%   gradient magnitude, gradients in different directions, min-max filter,
%   grayscale

    size = sqrt(feature_size);
    %grayscale = reshape(im, 1, feature_size);
    
    %[grad_mag,O] = gradientMag(im,0,0,0,0);
    %grad_mag = reshape(grad_mag,1,feature_size);
    %max_min = reshape(rangefilt(reshape(grayscale, size, size)),1,feature_size);
    %entropy = reshape(entropyfilt(reshape(im2double(grayscale), size, size)), 1, feature_size);
    %stdfilter = reshape(stdfilt(reshape(im2double(grayscale), size, size)), 1, feature_size);
    %perform gabor filtering
    %orientation = [0 45 90 135];
    %g = gabor(2, orientation);
    %outMag = imgaborfilt(im,g);
    %outMag = reshape(outMag, [1 feature_size 4]);
    patch_grad = reshape(grad(i-offset:i+offset-1,j-offset:j+offset-1), 1, feature_size);
    patch_grayscale = reshape(grayscale(i-offset:i+offset-1,j-offset:j+offset-1), 1, feature_size);
    patch_outMag1 = reshape(gabor1(i-offset:i+offset-1,j-offset:j+offset-1), 1, feature_size);
    patch_outMag2 = reshape(gabor2(i-offset:i+offset-1,j-offset:j+offset-1), 1, feature_size);
    patch_outMag3 = reshape(gabor3(i-offset:i+offset-1,j-offset:j+offset-1), 1, feature_size);
    patch_outMag4 = reshape(gabor4(i-offset:i+offset-1,j-offset:j+offset-1), 1, feature_size);
    gabor_channels = [patch_outMag1 patch_outMag2 patch_outMag3 patch_outMag4];
    x = [patch_grad patch_grayscale gabor_channels];
end

