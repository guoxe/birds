function x = extract_channels(im,channels,feature_size)
%EXTRACT_CHANNELS Extract different channels from the input image im
%(grayscale)
%   Extract various channel features from the image, such as:
%   gradient magnitude, gradients in different directions, min-max filter,
%   grayscale
    x = zeros(1,channels*feature_size);
    c1 = im;
    c1 = (c1-mean(c1)) ./ std(c1);%perform normalization
    [c2,O] = gradientMag(I,0,0,0,0);
    c2 = (c2-mean(c2)) ./ std(c2);%perform normalization
end

