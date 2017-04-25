%% Load training set and use it to train SVM
clear;
clc;
load('training_data_merged.mat');
size = 39;
feature_size = (size+1)^2;

X = zeros(16*length(training_data(:)), feature_size*2);%gradient mag + grayscale
labels = zeros(16,1);
labels(1:4) = 1;
Y = repmat(labels, [length(training_data(:)) 1]);

for i=1:length(training_data(:));
    %load the image, convert it to double and rescale it for numerical
    %purposes
    %add more channel
    im = rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray');
    [M1,O1]=gradientMag(im,0,0,0,0);
    im = im2double(im);
    pos_boxes = zeros(4,feature_size*2);%2 channels, gradient mag and grayscale
    neg_boxes = zeros(12,feature_size*2);%2 channels, gradient mag and grayscale
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    neg_x = training_data(i).negative(:,1);
    neg_y = training_data(i).negative(:,2);
    for  j=1:4; 
        box = reshape(imcrop(M1, 'single', [pos_x(j)-20 pos_y(j)-20 size size]), 1, feature_size);
        box = (box - mean(box)) ./ std(box); %rescale around 0 for numerical stability
        pos_boxes(j,:) = box;
        max_min = rangefilt(im);
        c1 = reshape(imcrop(M1, 'single', [pos_x(j)-20 pos_y(j)-20 size size]), 1, feature_size);%gradient magnitude
        c1 = (c1 - mean(c1)) ./ std(c1); %rescale around 0 for numerical stability
        c2 = reshape(imcrop(im, 'single', [pos_x(j)-20 pos_y(j)-20 size size]), 1, feature_size);%grayscale image
        c2 = (c2 - mean(c2)) ./ std(c2);
        pos_boxes(j,1:1600) = c1;
        pos_boxes(j,1601:3200) = c2;
    end;
    for j=1:12;
        c1 = reshape(imcrop(M1, 'single', [neg_x(j)-20 neg_y(j)-20 size size]), 1, feature_size);%gradient magnitude
        c1 = (c1 - mean(c1)) ./ std(c1); %rescale around 0 for numerical stability
        c2 = reshape(imcrop(im, 'single', [neg_x(j)-20 neg_y(j)-20 size size]), 1, feature_size);%grayscale
        c2 = (c2 - mean(c2)) ./ std(c2); %rescale around 0 for numerical stability
        neg_boxes(j,1:1600) = c1;
        neg_boxes(j,1601:3200) = c2;
    end;

    boxes = [pos_boxes;neg_boxes];
    X((i-1)*16 +1:16*i,:) = boxes;
end;
%fit a logistic model using glmfit
[B,dev] = glmfit(X, Y, 'binomial');
