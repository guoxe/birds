%% Load training set and use it to train SVM
clear;
clc;
load('training_data_merged.mat');
size = 39;
feature_size = (size+1)^2;

X = zeros(16*length(training_data(:)), feature_size);
labels = zeros(16,1);
labels(1:4) = 1;
Y = repmat(labels, [length(training_data(:)) 1]);

for i=1:length(training_data(:));
    %load the image, convert it to double and rescale it for numerical
    %purposes
    %add more channel
    im = rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray');
    [M1,O1]=gradientMag(im,0,0,0,0);
    pos_boxes = zeros(4,feature_size);
    neg_boxes = zeros(12,feature_size);
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    neg_x = training_data(i).negative(:,1);
    neg_y = training_data(i).negative(:,2);
    for  j=1:4; 
        box = reshape(imcrop(M1, 'single', [pos_x(j)-20 pos_y(j)-20 size size]), 1, feature_size);
        box = (box - mean(box)) ./ std(box); %rescale around 0 for numerical stability
        pos_boxes(j,:) = box;
    end;
    for j=1:12;
        box = reshape(imcrop(M1, 'single', [neg_x(j)-20 neg_y(j)-20 size size]), 1, feature_size);
        box = (box - mean(box)) ./ std(box); %rescale around 0 for numerical stability
        neg_boxes(j,:) = box;
    end;

    boxes = [pos_boxes;neg_boxes];
    X((i-1)*16 +1:16*i,:) = boxes;
end;
%fit a logistic model using glmfit
[B] = glmfit(X, Y, 'binomial');
