function [patch] = extract_patch(img_channels,i,j,sz)
%extract_patch Extract a patch of size sz x sz from the img_channels given,
%reshaped to 1x(sz x sz x channels). This function assumes sz is an odd
%number
    offset = floor(sz/2);
    feature_size = sz^2;
    patch = zeros(1,feature_size*size(img_channels,3));
    for k=1:size(img_channels,3)
        patch((k-1)*feature_size + 1:k*feature_size) = reshape(img_channels(i-offset:i+offset,j-offset:j+offset,k),1,feature_size);
    end
end

