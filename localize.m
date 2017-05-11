function [ x,y ] = localize(im, mask1, mask2, mask3, mask4, B,sz)
%LOCALIZE Return the locations of the 4 birds in the image im
    img_channels = extract_channels(im);
    %generate a probability map for each of the 4 cages
    m1=generate_heatmap(B,img_channels,mask1,sz);%heatmap for the first cage
    m2=generate_heatmap(B,img_channels,mask2,sz);%heatmap for the second cage
    m3=generate_heatmap(B,img_channels,mask3,sz);%heatmap for the third cage
    m4=generate_heatmap(B,img_channels,mask4,sz);%heatmap for the fourth cage
    %find the peaks
    [~,Im1] = max(m1(:));
    [y1, x1] = ind2sub(size(m1), Im1);
    [~, Im2] = max(m2(:));
    [y2, x2] = ind2sub(size(m2), Im2);
    [~, Im3] = max(m3(:));
    [y3, x3] = ind2sub(size(m3), Im3);
    [~, Im4] = max(m4(:));
    [y4, x4] = ind2sub(size(m4), Im4);
    y = [y1;y2;y3;y4];
    x = [x1;x2;x3;x4];
end

