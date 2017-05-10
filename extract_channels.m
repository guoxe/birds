function [img_channels] = extract_channels(im)
%EXTRACT_CHANNELS Extract different channels from the input image im
%(grayscale)
%   Extract various channel features from the image, such as:
%   gradient magnitude, gradients in different directions, min-max filter,
%   grayscale
    [grad_mag,~] = gradientMag(im,0,0,0,0); % gradmag filtering
    % gabor filtering
    orientation = [0 30 60 90 120 150];
    g = gabor(2, orientation);
    outMag = imgaborfilt(im,g);
    img_channels = zeros(size(im,1), size(im,2), 8);
    img_channels(:,:,1) = im;
    img_channels(:,:,2) = grad_mag;
    for i=1:size(outMag,3)
        img_channels(:,:,i+2) = outMag(:,:,i);
    end
end

