function [ hm ] = generate_heatmap(B,img)
%GENERATE_HEATMAP Generate a heatmap of classifier responses for the given
%image mask
%   Given an input image this function will return a heatmap of values
%   between [0,1] corresponding to the classifier responses for each pixel
%   of the input image.
    idx = find(img ~= 0);
    hm = zeros(size(img));
    for k=1:length(idx)
        [j,i] = ind2sub(size(img), idx(k));
        I = imcrop(img,'single', [i-20 j-20 19 19]);
        x=extract_channels(I,2,400);%add proper feature sizes + channels?
        hm(j,i) = glmval(B,x,'logit');
    end
end

