%% Locate the birds by running the classifier on the masked image data
clc;
clear;
%load the image masks
load mask1_2.mat;
load mask2_2.mat;
load mask3_2.mat;
load mask4_2.mat;
% load gabor1.mat;
% load gabor2.mat;
% load gabor3.mat;
% load gabor4.mat;
% load gabor.mat;
% load grayscale.mat;
% load grad.mat;
%load mask_t.mat;
load model_weights_30x30_6.mat;%load the model weights
sz=29;

imagefiles = dir('videos/frames/*.jpg');%generate a list of all the image files
for i=1:1%loop through all the imagefiles
    im = rgbConvert(imread(strcat('videos/frames/',imagefiles(i).name)),'gray');
    [grad_mag,O] = gradientMag(im,0,0,0,0); % gradmag filtering
    % gabor filtering
    orientation = [0 45 90 135];
    g = gabor(2, orientation);
    outMag = imgaborfilt(im,g);
    gabor1 = outMag(:,:,1);
    gabor2 = outMag(:,:,2);
    gabor3 = outMag(:,:,3);
    gabor4 = outMag(:,:,4);
    %mask out the cages
    m1=generate_heatmap(B,im,grad_mag,gabor1,gabor2,gabor3,gabor4,mask1,sz);%heatmap for the first cage
    m2=generate_heatmap(B,im,grad_mag,gabor1,gabor2,gabor3,gabor4,mask2,sz);%heatmap for the second cage
    m3=generate_heatmap(B,im,grad_mag,gabor1,gabor2,gabor3,gabor4,mask3,sz);%heatmap for the third cage
    m4=generate_heatmap(B,im,grad_mag,gabor1,gabor2,gabor3,gabor4,mask4,sz);%heatmap for the fourth cage
    %find the peaks, after doing a crude noise filter (remove values <
    %0.5)
    m1 = bsxfun(@times, m1, bsxfun(@ge, m1, 0.85));
    m2 = bsxfun(@times, m2, bsxfun(@ge, m2, 0.85));
    m3 = bsxfun(@times, m3, bsxfun(@ge, m3, 0.85));
    m4 = bsxfun(@times, m4, bsxfun(@ge, m4, 0.85));
    p1 = FastPeakFind(m1);
    p2 = FastPeakFind(m2);
    p3 = FastPeakFind(m3);
    p4 = FastPeakFind(m4);
    imshow(im);
    hold on;
    plot(p1(1:2:end),p1(2:2:end),'r+');
    plot(p2(1:2:end),p2(2:2:end),'r+');
    plot(p3(1:2:end),p3(2:2:end),'r+');
    plot(p4(1:2:end),p4(2:2:end),'r+');
    hold off;
end