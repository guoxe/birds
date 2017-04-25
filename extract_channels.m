function x = extract_channels(im,channels,feature_size)
%EXTRACT_CHANNELS Extract different channels from the input image im
%(grayscale)
%   Extract various channel features from the image, such as:
%   gradient magnitude, gradients in different directions, min-max filter,
%   grayscale
    grayscale = reshape(im, 1, feature_size);
    grayscale = (grayscale-mean(grayscale)) ./ std(grayscale);%perform normalization
    [grad_mag,O] = gradientMag(im,0,0,0,0);
    grad_mag = reshape(grad_mag,1,feature_size);
    max_min = reshape(rangefilt(reshape(grayscale, 40, 40)),1,feature_size);
    entropy = reshape(entropyfilt(reshape(im2double(im), 40, 40)), 1, feature_size);
    stdfilter = reshape(stdfilt(reshape(im2double(im), 40, 40)), 1, feature_size);
    x = [grad_mag grayscale max_min entropy stdfilter];
end

