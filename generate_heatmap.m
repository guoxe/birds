function [ hm ] = generate_heatmap(B,img_channels,mask,sz)
%GENERATE_HEATMAP Generate a heatmap of classifier responses for the given
%image mask
%   Given an input image this function will return a heatmap of values
%   between [0,1] corresponding to the classifier responses for each pixel
%   of the input image.
    idx = find(mask ~= 0);
    hm = zeros(size(mask));
    step = 32;
    for k=1:step:length(idx)
        [i,j] = ind2sub(size(mask), idx(k));
        x=extract_patch(img_channels,i,j,sz);
        hm(i,j) = glmval(B,x,'logit');
        if hm(i,j) >= 0.4
            step = ceil(step / 8);
        else
            step = 32;
        end
    end
end

