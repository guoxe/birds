function [ hm ] = generate_heatmap(B,img,mask,sz)
%GENERATE_HEATMAP Generate a heatmap of classifier responses for the given
%image mask
%   Given an input image this function will return a heatmap of values
%   between [0,1] corresponding to the classifier responses for each pixel
%   of the input image.
    features = (sz+1)^2;
    idx = find(mask ~= 0);
    hm = zeros(size(mask));
    for k=1:length(idx)
        [i,j] = ind2sub(size(mask), idx(k));
        %I = imcrop(img,'single', [i-(sz+1) j-(sz+1) sz sz]);
        offset = (sz+1)/2;
        patch = img(i-offset:i+offset-1,j-offset:j+offset-1);
        x=extract_channels(patch,8,features);
        hm(i,j) = glmval(B,x,'logit');
    end
end

