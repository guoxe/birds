%% Locate the birds by running the classifier on the masked image data
clc;
clear;
%load the image masks
load mask1.mat;
load mask2.mat;
load mask3.mat;
load mask4.mat;
load model_weights.mat;%load the model weights

imagefiles = dir('videos/frames/*.jpg');%generate a list of all the image files
for i=1:1%loop through all the imagefiles
    im = rgbConvert(imread(strcat('videos/frames/',imagefiles(i).name)),'gray');
    %mask out the cages
    I1 = bsxfun(@times, im, mask1);
    I2 = bsxfun(@times, im, mask2);
    I3 = bsxfun(@times, im, mask3);
    I4 = bsxfun(@times, im, mask4);
    m1=generate_heatmap(B,I1);%heatmap for the first cage
    m2=generate_heatmap(B,I2);%heatmap for the second cage
    m3=generate_heatmap(B,I3);%heatmap for the third cage
    m4=generate_heatmap(B,I4);%heatmap for the fourth cage
end